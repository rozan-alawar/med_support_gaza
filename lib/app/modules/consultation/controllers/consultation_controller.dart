import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';

class ConsultationController extends GetxController {
  final RxInt activeConsultations = 0.obs;
  final RxList<ConsultationModel> consultations = <ConsultationModel>[].obs;
  final RxBool isLoading = false.obs;

  // Mock data for testing
  @override
  void onInit() {
    super.onInit();
    // Add some sample consultations
    consultations.addAll([
      ConsultationModel(
        id: '1',
        doctorName: 'Dr. Sarah Wilson',
        specialty: 'Cardiology',
        date: DateTime.now().add(const Duration(days: 1)), // Tomorrow
        time: '14:00',
        status: 'upcoming',
      ),
      ConsultationModel(
        id: '2',
        doctorName: 'Dr. Michael Chen',
        specialty: 'Neurology',
        date: DateTime.now(),
        time: '10:30',
        status: 'active',
      ),
    ]);

    // Update active consultations count
    updateActiveConsultations();
  }

  void updateActiveConsultations() {
    activeConsultations.value = consultations
        .where((c) => c.status == 'active')
        .length;
  }

  // Get consultations by status
  List<ConsultationModel> getConsultationsByStatus(String status) {
    return consultations
        .where((consultation) => consultation.status == status)
        .toList();
  }

  // Check if user can make new consultation
  bool canBookNewConsultation(DateTime proposedDate, String proposedTime) {
    // Check if there's any active or upcoming consultation at the same time
    return !consultations.any((consultation) =>
    consultation.status != 'completed' &&
        consultation.date.year == proposedDate.year &&
        consultation.date.month == proposedDate.month &&
        consultation.date.day == proposedDate.day &&
        consultation.time == proposedTime
    );
  }

  // Add new consultation
  void addConsultation(ConsultationModel consultation) {
    if (canBookNewConsultation(consultation.date, consultation.time)) {
      consultations.add(consultation);
      updateActiveConsultations();
    } else {
      Get.snackbar(
        'Error',
        'You already have a consultation at this time',
        backgroundColor: Colors.red[100],
        colorText: Colors.red[900],
      );
    }
  }
}
