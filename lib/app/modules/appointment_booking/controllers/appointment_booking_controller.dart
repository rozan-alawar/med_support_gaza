import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/modules/home/controllers/home_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AppointmentBookingController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final RxInt currentStep = 0.obs;
  final RxString selectedSpecialization = ''.obs;
  final RxString selectedDoctor = ''.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();
  final RxBool isLoading = false.obs;
  final RxString selectedDoctorId = ''.obs;
  final RxString selectedDoctorName = ''.obs;

  final RxList<DoctorModel> availableDoctors = <DoctorModel>[].obs;

  // Patient data from auth
  String? get patientId => _firebaseService.currentUser?.uid;
  String get patientName => "${_firebaseService.patientData.value?.firstName} ${_firebaseService.patientData.value?.lastName}" ?? '';

  void selectDoctor(DoctorModel doctor) {
    selectedDoctorId.value = doctor.id;
    selectedDoctorName.value = "${doctor.firstName} ${doctor.lastName}";
  }


  Future<void> confirmBooking() async {
    try {
      isLoading.value = true;

      final appointment = AppointmentModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        patientId: patientId!,
        doctorId: selectedDoctorId.value,
        doctorName: selectedDoctorName.value,
        patientName: patientName,
        specialization: selectedSpecialization.value,
        dateTime: DateTime(
          selectedDate.value!.year,
          selectedDate.value!.month,
          selectedDate.value!.day,
          selectedTime.value!.hour,
          selectedTime.value!.minute,
        ),
      );

      await _firebaseService.saveAppointment(appointment);

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Appointment booked successfully'.tr,
      );

      Get.offNamed(Routes.HOME);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  final List<String> stepTitles = [
    'SelectSpecialization',
    'SelectDoctor',
    'ChooseTime',
    'ConfirmBooking'
  ];

  List<TimeOfDay> getAvailableTimes() {
    return [
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 9, minute: 30),
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 10, minute: 30),
      const TimeOfDay(hour: 11, minute: 0),
      const TimeOfDay(hour: 11, minute: 30),
    ];
  }

  List<Map<String, dynamic>> getSpecializations() {
    return [
      {'id': 1, 'title': 'Cardiology', 'availableDoctors': 4},
      {'id': 2, 'title': 'Neurology', 'availableDoctors': 3},
      {'id': 3, 'title': 'Pediatrics', 'availableDoctors': 5},
      {'id': 4, 'title': 'Orthopedics', 'availableDoctors': 3},
      {'id': 5, 'title': 'Dermatology', 'availableDoctors': 2},
      {'id': 6, 'title': 'Ophthalmology', 'availableDoctors': 3},
    ];
  }

  List<Map<String, dynamic>> getDoctors() {
    final doctors = {
      'Cardiology': [
        {'name': 'Dr. Ahmed Mohammed', 'rating': 4.8, 'experience': '15 years'},
        {'name': 'Dr. Sarah Wilson', 'rating': 4.6, 'experience': '12 years'},
      ],
      'Neurology': [
        {'name': 'Dr. Michael Chen', 'rating': 4.9, 'experience': '20 years'},
        {'name': 'Dr. Emma Davis', 'rating': 4.7, 'experience': '10 years'},
      ],
    };

    return (doctors[selectedSpecialization.value] ?? [])
        .map((doctor) => {
      ...doctor,
      'specialization': selectedSpecialization.value,
    })
        .toList();
  }

  void selectSpecialization(String specialization) {
    selectedSpecialization.value = specialization;
    selectedDoctor.value = '';  // Reset doctor selection
  }

  Future<void> fetchDoctorsBySpecialty(String specialty) async {
    try {
      isLoading.value = true;
      availableDoctors.value = await _firebaseService.getDoctorsBySpecialty(specialty);
    } catch (e) {
      print('Error fetching doctors: $e');
      Get.snackbar('Error', 'Failed to fetch doctors');
    } finally {
      isLoading.value = false;
    }
  }


  bool validateBooking() {
    if (patientId == null) {
      Get.snackbar('Error', 'Please login first');
      return false;
    }

    if (selectedDoctorId.isEmpty) {
      Get.snackbar('Error', 'Please select a doctor');
      return false;
    }

    if (selectedDate.value == null) {
      Get.snackbar('Error', 'Please select a date');
      return false;
    }

    if (selectedTime.value == null) {
      Get.snackbar('Error', 'Please select a time');
      return false;
    }

    return true;
  }

  void selectTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  void nextStep() {
    if (currentStep.value == 0 && selectedSpecialization.value.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'PleaseSelectSpecialization'.tr,
      );
      return;
    }

    if (currentStep.value == 1 && selectedDoctor.value.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'PleaseSelectDoctor'.tr,
      );
      return;
    }

    if (currentStep.value == 2 && selectedTime.value == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'PleaseSelectTime'.tr,
      );
      return;
    }

    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      confirmBooking();
    }
  }}
