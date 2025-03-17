import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/firebase_services/chat_services.dart';
import '../../../data/models/consultation_model.dart';
import '../../profile/controllers/doctor_profile_controller.dart';

class DoctorConsultationController extends GetxController {
  final activeConsultations = <ConsultationModel>[].obs;
  final upcomingConsultations = <ConsultationModel>[].obs;
  final pastConsultations = <ConsultationModel>[].obs;
  final ChatService _chatService = ChatService();
  final doctorController = Get.find<DoctorProfileController>();

  void onInit() {
    super.onInit();
    loadConsultations();
    startStatusChecker(); // بدء الفحص الدوري لتحديث الحالة
  }

  void loadConsultations() {
    // استماع للاستشارات النشطة
    _chatService
        .getDoctorConsultations(doctorController.doctorData.value?.doctor?.id ?? 0, 'active')
        .listen((consultations) {
      activeConsultations.value = consultations;
    });

    // استماع للاستشارات القادمة
    _chatService
        .getDoctorConsultations(doctorController.doctorData.value?.doctor?.id ?? 0, 'upcoming')
        .listen((consultations) {
      upcomingConsultations.value = consultations;
    });

    // استماع للاستشارات الماضية
    _chatService
        .getDoctorConsultations(doctorController.doctorData.value?.doctor?.id ?? 0, 'past')
        .listen((consultations) {
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
    Timer.periodic(const Duration(minutes: 1), (timer) {
      _checkConsultationStatuses();
    });
  }


 void _checkConsultationStatuses() {
    final allConsultations = [...upcomingConsultations, ...activeConsultations];
    for (var consultation in allConsultations) {
      final expectedStatus = _getConsultationStatus(consultation.startTime, consultation.endTime);
      if (consultation.status != expectedStatus) {
        // @TODO 
        // change consultation id to consultation.appointmentId with the request is ready
        _chatService.updateConsultationStatusByDoctor(consultation.id, expectedStatus);
      }
    }
  }


  var messages = [
    {
      'name': 'أمير العطار',
      'message': 'شكراً لك دكتور',
      'time': 'اليوم، 2:00 م'
    },
    {
      'name': 'أمير العطار',
      'message': 'أنا أنتظر الرد',
      'time': 'اليوم، 2:00 م'
    },
    {
      'name': 'أمير العطار',
      'message': 'أنا أعاني من...',
      'time': 'اليوم، 2:00 م'
    },
    {
      'name': 'أمير العطار',
      'message': 'أنا أنتظر الرد',
      'time': 'اليوم، 2:00 م'
    },
    {'name': 'saja', 'message': 'مرحبا بك', 'time': 'اليوم، 2:00 م'},
  ].obs;
}
