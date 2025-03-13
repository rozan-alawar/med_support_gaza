import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';
import 'package:med_support_gaza/app/modules/consultation/views/pages/chat_view.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';


class ConsultationsController extends GetxController {
  final ChatService _chatService = ChatService();
  final String userId;

  final activeConsultations = <ConsultationModel>[
    ConsultationModel(id: "215", doctorId: "5451", doctorName: "doctorName", patientId: "patientId", patientName: "patientName", startTime: Timestamp.now(), endTime: Timestamp.fromDate(DateTime.now()), status: "active")
  ].obs;
  final upcomingConsultations = <ConsultationModel>[].obs;
  final pastConsultations = <ConsultationModel>[].obs;
  final isLoading = true.obs;

  ConsultationsController({required this.userId});

  @override
  void onInit() {
    super.onInit();
    _loadConsultations();
  }

  void _loadConsultations() {
    // Listen to active consultations
    _chatService.getConsultations(userId, 'active').listen((snapshot) {
      activeConsultations.value = _mapConsultations(snapshot);
      isLoading.value = false;
    });

    // Listen to upcoming consultations
    _chatService.getConsultations(userId, 'upcoming').listen((snapshot) {
      upcomingConsultations.value = _mapConsultations(snapshot);
    });

    // Listen to past consultations
    _chatService.getConsultations(userId, 'past').listen((snapshot) {
      pastConsultations.value = _mapConsultations(snapshot);
    });
  }

  List<ConsultationModel> _mapConsultations(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return ConsultationModel.fromMap(
          doc.id,
          doc.data() as Map<String, dynamic>
      );
    }).toList();
  }

  // Check and update consultation statuses periodically
  void startStatusChecker() {
    Timer.periodic(Duration(minutes: 1), (timer) {
      _checkConsultationStatuses();
    });
  }

  void _checkConsultationStatuses() {
    final now = Timestamp.now();

    // Check if any upcoming consultations should be active
    for (var consultation in upcomingConsultations) {
      if (now.compareTo(consultation.startTime) >= 0) {
        _chatService.updateConsultationStatus(consultation.id, 'active');
      }
    }

    // Check if any active consultations should be past
    for (var consultation in activeConsultations) {
      if (now.compareTo(consultation.endTime) >= 0) {
        _chatService.updateConsultationStatus(consultation.id, 'past');
      }
    }
  }

  // Navigate to chat screen
  void openChat(ConsultationModel consultation) {
    Get.to(() => ChatView(
      consultationId: consultation.id,
      userId: userId,
    ));
  }
}