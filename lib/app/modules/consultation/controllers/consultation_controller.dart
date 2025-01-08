import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/models/message_model.dart';

class ConsultationController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid??1;
  final messageController = TextEditingController();

  final RxList<MessageModel> messages = <MessageModel>[].obs;

  late StreamSubscription<QuerySnapshot> _messagesSubscription;

  @override
  void onInit() {
    super.onInit();
    _setupMessagesListener();
  }

  void _setupMessagesListener() {
    _messagesSubscription = _firestore
        .collection('chats')
        .doc(_getChatId())
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => MessageModel.fromJson(doc.data()))
          .toList();
    });
  }

  String _getChatId() {
    final List<String> ids = ["currentUserId"," doctor.id"]..sort();
    return ids.join('_');
  }

  Future<void> sendMessage() async {
    if (messageController.text
        .trim()
        .isEmpty) return;

    final message = MessageModel(
      id: DateTime
          .now()
          .millisecondsSinceEpoch
          .toString(),
      senderId: "currentUserId",
      receiverId: "doctor.id",
      content: messageController.text.trim(),
      timestamp: DateTime.now(),
    );

    try {
      await _firestore
          .collection('chats')
          .doc(_getChatId())
          .collection('messages')
          .doc(message.id)
          .set(message.toJson());

      messageController.clear();
    } catch (e) {
      print('Error sending message: $e');
      Get.snackbar('Error', 'Failed to send message');
    }
  }

  void startVoiceRecord() {
  }

  @override
  void onClose() {
    _messagesSubscription.cancel();
    messageController.dispose();
    super.onClose();
  }
}