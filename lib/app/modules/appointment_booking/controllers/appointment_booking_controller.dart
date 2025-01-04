import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';

class AppointmentBookingController extends GetxController {
  final RxInt currentStep = 0.obs;
  final RxString selectedSpecialization = ''.obs;
  final RxString selectedDoctor = ''.obs;
  final Rxn<DateTime> selectedDate = Rxn<DateTime>();

  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();

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

  void selectTime(TimeOfDay time) {
    selectedTime.value = time;
  }

  final List<String> stepTitles = [
    'SelectSpecialization',
    'SelectDoctor',
    'ChooseTime',
    'ConfirmBooking'
  ];
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
  }

  void selectSpecialization(String specialization) {
    selectedSpecialization.value = specialization;
  }

  void selectDoctor(String doctor) {
    selectedDoctor.value = doctor;
  }

  void confirmBooking() {
    // Implement booking confirmation logic
    print('Booking confirmed');
    // You can make API calls here
  }

  // Mock data methods - Replace with actual API calls
  List<Map<String, dynamic>> getSpecializations() {
    return List.generate(
      6,
      (index) => {
        'id': index + 1,
        'title': 'Specialization ${index + 1}',
        'availableDoctors': index + 4,
      },
    );
  }

  List<Map<String, dynamic>> getDoctors() {
    return List.generate(
      5,
      (index) => {
        'id': index + 1,
        'name': 'Dr. Name ${index + 1}',
        'specialization': selectedSpecialization.value,
        'rating': 4.5,
        'experience': '${5 + index} years',
      },
    );
  }
}
