import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final int userId;
  final String consultationId;

  // Observable variables
  final messages = <MessageModel>[].obs;
  final consultation = Rx<ConsultationModel?>(null);
  final isLoading = true.obs;
  final message = ''.obs;
  final remainingTime = ''.obs;
  Timer? _timer;

  ChatController({required this.userId, required this.consultationId});

  @override
  void onInit() {
    super.onInit();
    _loadConsultation();
    _listenToMessages();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void _loadConsultation() {
    _chatService.getConsultation(consultationId).listen((consultationModel) {
      consultation.value = consultationModel;
      isLoading.value = false;

      // Start timer if consultation is active
      if (consultation.value?.status == 'active') {
        _startTimer();
      }
    });
  }

  void _listenToMessages() {
    _chatService.getMessages(consultationId).listen((snapshot) {
      messages.value = snapshot.docs
          .map((doc) =>
              MessageModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  void sendMessage() {
    if (message.value.trim().isEmpty) return;

    // Only allow sending if consultation is active
    if (consultation.value?.status == 'active') {
      _chatService.sendMessage(
          consultationId,
          userId,
          '${consultation.value!.doctor.firstName} ${consultation.value!.doctor.lastName}',
          message.value);
      message.value = '';
    }
  }

  void _startTimer() {
    final endTime = consultation.value?.endTime;
    if (endTime == null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final now = Timestamp.now();
      final diff = endTime.seconds - now.seconds;

      if (diff <= 0) {
        timer.cancel();
        _chatService.updateConsultationStatus(consultationId, 'past');
        remainingTime.value = 'Consultation ended';
      } else {
        final minutes = diff ~/ 60;
        final seconds = diff % 60;
        remainingTime.value = '${minutes}m ${seconds}s remaining';
      }
    });
  }

  bool get canSendMessage {
    return consultation.value?.status == 'active';
  }

  bool get isConsultationPast {
    return consultation.value?.status == 'past';
  }

  bool get isConsultationUpcoming {
    return consultation.value?.status == 'upcoming';
  }
}
