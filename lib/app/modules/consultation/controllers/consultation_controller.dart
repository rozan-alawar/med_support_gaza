import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class ConsultationModel {
  final String id;
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;
  final String status; // 'upcoming', 'active', 'completed'

  ConsultationModel({
    required this.id,
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.status,
  });

  // Get doctor initials
  String get doctorInitials {
    final nameParts = doctorName.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return doctorName.substring(0, 2).toUpperCase();
  }

  // Format date
  String get formattedDate {
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    }
    return '${date.day}/${date.month}/${date.year}';
  }

  // Check if consultation is happening now
  bool get isActive => status == 'active';

  // Check if consultation can be joined
  bool get canJoin {
    if (status != 'upcoming' && status != 'active') return false;

    final now = DateTime.now();
    final consultationHour = int.parse(time.split(':')[0]);
    final consultationMinute = int.parse(time.split(':')[1]);

    final consultationTime = DateTime(
      date.year,
      date.month,
      date.day,
      consultationHour,
      consultationMinute,
    );

    // Can join 5 minutes before until 30 minutes after start time
    return now.isAfter(consultationTime.subtract(const Duration(minutes: 5))) &&
        now.isBefore(consultationTime.add(const Duration(minutes: 30)));
  }
}