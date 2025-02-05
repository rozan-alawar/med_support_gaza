// lib/app/modules/chat/controllers/chat_controller.dart

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';
import 'package:med_support_gaza/app/data/models/message_model.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:file_picker/file_picker.dart';

class ChatController extends GetxController {
  final consultation = Get.arguments as ConsultationModel;
  final messageController = TextEditingController();
  final messages = <MessageModel>[].obs;
  final isLoading = false.obs;
  final remainingTime = ''.obs;
  late Timer consultationTimer;

  String get currentUserId => 'current_user_id'; // Replace with actual user ID

  @override
  void onInit() {
    super.onInit();
    loadMessages();
    startConsultationTimer();
  }

  @override
  void onClose() {
    messageController.dispose();
    consultationTimer.cancel();
    super.onClose();
  }

  void startConsultationTimer() {
    consultationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final consultationEnd = DateTime(
        consultation.date.year,
        consultation.date.month,
        consultation.date.day,
        int.parse(consultation.time.split(':')[0]),
        int.parse(consultation.time.split(':')[1]),
      ).add(const Duration(minutes: 30)); // Assuming 30-minute consultations

      if (now.isAfter(consultationEnd)) {
        timer.cancel();
        remainingTime.value = 'Consultation ended';
        endConsultation();
      } else {
        final difference = consultationEnd.difference(now);
        remainingTime.value =
        '${difference.inMinutes}:${(difference.inSeconds % 60).toString().padLeft(2, '0')} remaining';
      }
    });
  }

  Future<void> loadMessages() async {
    try {
      isLoading.value = true;
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      messages.value = _getMockMessages();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to load messages',
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;

    try {
      final newMessage = MessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        text: messageController.text.trim(),
        senderId: currentUserId,
        timestamp: DateTime.now(),
        type: MessageType.text,
      );

      messages.insert(0, newMessage);
      messageController.clear();

      // Simulate API call to send message
      await Future.delayed(const Duration(milliseconds: 500));

      // Simulate doctor's response after 1 second
      if (messages.length % 3 == 0) {
        await Future.delayed(const Duration(seconds: 1));
        final response = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: 'Thank you for your message. How can I help you today?',
          senderId: 'doctor_${consultation.id}',
          timestamp: DateTime.now(),
          type: MessageType.text,
        );
        messages.insert(0, response);
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to send message',
      );
    }
  }

  Future<void> pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        final file = result.files.first;
        // Handle file upload
        final newMessage = MessageModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: file.name,
          senderId: currentUserId,
          timestamp: DateTime.now(),
          type: MessageType.file,
          fileUrl: 'file_url', // Replace with actual file URL after upload
          fileName: file.name,
          fileSize: file.size,
        );
        messages.insert(0, newMessage);
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to pick file',
      );
    }
  }

  void endConsultation() {
    CustomSnackBar.showCustomToast(
      message: 'Consultation time has ended',
      color: Colors.red,
    );
    // Implement consultation end logic
  }

  String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  List<MessageModel> _getMockMessages() {
    return [
      MessageModel(
        id: '1',
        text: 'Hello! How can I help you today?',
        senderId: 'doctor_${consultation.id}',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        type: MessageType.text,
      ),
      MessageModel(
        id: '2',
        text: 'Hi doctor, I have some questions about my condition.',
        senderId: currentUserId,
        timestamp: DateTime.now().subtract(const Duration(minutes: 4)),
        type: MessageType.text,
      ),
    ];
  }
}