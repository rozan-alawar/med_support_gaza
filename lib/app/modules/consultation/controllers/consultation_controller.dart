
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';
import 'package:med_support_gaza/app/modules/consultation/views/pages/chat_view.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

import '../../appointment_booking/controllers/appointment_booking_controller.dart';

class ConsultationsController extends GetxController {
  final ChatService _chatService = ChatService();
  final int userId;


  final activeConsultations = <ConsultationModel>[].obs;
  final upcomingConsultations = <ConsultationModel>[].obs;
  final pastConsultations = <ConsultationModel>[].obs;
  final isLoading = true.obs;

  ConsultationsController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    loadConsultations();
    startStatusChecker(); // بدء الفحص الدوري لتحديث الحالة
  }

  void loadConsultations() {
    // استماع للاستشارات النشطة
    _chatService.getPatientConsultations(userId, 'active', DateTime.now()).listen((consultations) {
      activeConsultations.value = consultations;
    });

    // استماع للاستشارات القادمة
    _chatService.getPatientConsultations(userId, 'upcoming', DateTime.now()).listen((consultations) {
      upcomingConsultations.value = consultations;
    });

    // استماع للاستشارات الماضية
    _chatService.getPatientConsultations(userId, 'past', DateTime.now()).listen((consultations) {
      pastConsultations.value = consultations;
    });
  }

  String _getConsultationStatus(Timestamp startTime, Timestamp endTime) {
    final now = Timestamp.now();
    if (now.compareTo(startTime) < 0) {
      return 'upcoming';
    } else if (now.compareTo(endTime) < 0) {
      return 'active';
    } else {
      return 'past';
    }
  }

  void startStatusChecker() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      _checkConsultationStatuses();
    });
  }

  void _checkConsultationStatuses() {
    final allConsultations = [...upcomingConsultations, ...activeConsultations];
    for (var consultation in allConsultations) {
      final expectedStatus = _getConsultationStatus(consultation.startTime, consultation.endTime);
      if (consultation.status != expectedStatus) {
        _chatService.updateConsultationStatus(consultation.id, expectedStatus);
      }
    }
  }

  void openChat(ConsultationModel consultation) {
    Get.to(() => ChatView(
      consultationId: consultation.id,
      userId: userId,
    ));
  }
}
