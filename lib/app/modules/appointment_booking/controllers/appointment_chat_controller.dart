import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/data/models/chat_model.dart';

class AppointmentChatController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final ImagePicker _picker = ImagePicker();

  final RxList<ChatMessage> messages = <ChatMessage>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSending = false.obs;
  final RxBool isVideoCallActive = false.obs;
  final RxString appointmentStatus = ''.obs;
  late AppointmentModel appointment;
  late String currentUserId;
  late String otherUserId;
  late bool isDoctor;

  @override
  void onInit() {
    super.onInit();
    appointment = Get.arguments['appointment'];
    currentUserId = Get.arguments['currentUserId'];
    isDoctor = Get.arguments['isDoctor'];
    // otherUserId = isDoctor ? appointment.patientId : appointment.doctorId;
    _listenToMessages();
    _listenToAppointmentStatus();
  }

  void _listenToMessages() {
    _firestore
        .collection('chats')
        .where('appointmentId', isEqualTo: appointment.id)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) => ChatMessage.fromJson({...doc.data(), 'id': doc.id}))
          .toList();
    });
  }

  void _listenToAppointmentStatus() {
    _firestore
        .collection('appointments')
        .doc(appointment.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        appointmentStatus.value = snapshot.data()?['status'] ?? '';
      }
    });
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    try {
      isSending.value = true;
      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUserId,
        receiverId: otherUserId,
        message: message,
        messageType: 'text',
        timestamp: DateTime.now(),
        appointmentId: appointment.id,
      );

      await _firestore.collection('chats').add(newMessage.toJson());
    } catch (e) {
      print('Error sending message: $e');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> sendImage() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;

      isSending.value = true;
      final ref = _storage.ref().child('chat_images/${DateTime.now()}.jpg');
      await ref.putFile(File(image.path));
      final url = await ref.getDownloadURL();

      final newMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        senderId: currentUserId,
        receiverId: otherUserId,
        message: 'Image',
        messageType: 'image',
        timestamp: DateTime.now(),
        fileUrl: url,
        appointmentId: appointment.id,
      );

      await _firestore.collection('chats').add(newMessage.toJson());
    } catch (e) {
      print('Error sending image: $e');
    } finally {
      isSending.value = false;
    }
  }

  Future<void> startVideoCall() async {
    try {
      isVideoCallActive.value = true;
      // Implement video call logic here
      // You might want to use a service like Agora or Twilio
    } catch (e) {
      print('Error starting video call: $e');
      isVideoCallActive.value = false;
    }
  }

  Future<void> endVideoCall() async {
    isVideoCallActive.value = false;
    // Implement end call logic
  }

  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _firestore
          .collection('chats')
          .doc(messageId)
          .update({'isRead': true});
    } catch (e) {
      print('Error marking message as read: $e');
    }
  }

  Future<void> updateAppointmentStatus(String status) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .update({'status': status});
    } catch (e) {
      print('Error updating appointment status: $e');
    }
  }
}