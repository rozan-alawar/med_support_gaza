import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/data/models/specialization_model.dart';
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
  final RxList<SpecializationModel> specializations = <SpecializationModel>[]
      .obs;
  final RxString error = ''.obs;

  final RxList<DoctorModel> availableDoctors = <DoctorModel>[].obs;

  final RxBool isLoadingDoctors = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  // Patient data from auth
  String? get patientId => _firebaseService.currentUser?.uid;

  String get patientName =>
      "${_firebaseService.patientData.value?.firstName} ${_firebaseService
          .patientData.value?.lastName}" ?? '';


  @override
  void onInit() {
    super.onInit();
    ever(selectedSpecialization, (_) => loadDoctors());
  }

  Future<void> loadDoctors() async {
    if (selectedSpecialization.value.isEmpty) return;

    try {
      isLoadingDoctors.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Query Firestore for doctors
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('speciality', isEqualTo: selectedSpecialization.value)
          .where('isApproved', isEqualTo: true)
          .get();

      // Convert to DoctorModel list
      final List<DoctorModel> doctors = querySnapshot.docs
          .map((doc) =>
          DoctorModel.fromJson(doc.data() as Map<String, dynamic>))
          .where((doctor) =>
      doctor.isAvailable) // Filter only available doctors
          .toList();

      // Sort by rating
      doctors.sort((a, b) => b.rating.compareTo(a.rating));

      availableDoctors.value = doctors;
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      availableDoctors.clear();
    } finally {
      isLoadingDoctors.value = false;
    }
  }

  void selectDoctor(DoctorModel doctor) {
    selectedDoctorId.value = doctor.id;
    selectedDoctor.value = "${doctor.firstName} ${doctor.lastName}";

    // Reset time selection when doctor changes
    selectedTime.value = null;
    selectedDate.value = null;
  }

  void nextStep() {
    if (currentStep.value == 0 && selectedSpecialization.value.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Please select a specialization'.tr,
      );
      return;
    }

    if (currentStep.value == 1 && selectedDoctorId.value.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Please select a doctor'.tr,
      );
      return;
    }

    if (currentStep.value == 2 &&selectedTime.value == null) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Please select date and time'.tr,
      );
      return;
    }

    if (currentStep.value < 3) {
      currentStep.value++;
    } else {
      confirmBooking();
    }
  }

  List<TimeOfDay> getAvailableTimeSlots(DoctorModel doctor, DateTime date) {
    final dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday

    // Find working hours for selected day
    final workingHours = doctor.workingHours.firstWhere(
          (wh) => wh.dayOfWeek == dayOfWeek,
      orElse: () =>
          WorkingHours(
              dayOfWeek: dayOfWeek,
              startTime: '09:00',
              endTime: '17:00',
              isAvailable: false
          ),
    );

    if (!workingHours.isAvailable) return [];

    // Convert string times to TimeOfDay
    final startTime = _parseTimeString(workingHours.startTime);
    final endTime = _parseTimeString(workingHours.endTime);

    // Generate 30-minute slots
    final slots = <TimeOfDay>[];
    var currentTime = startTime;

    while (_timeToDouble(currentTime) <= _timeToDouble(endTime)) {
      slots.add(currentTime);
      currentTime = TimeOfDay(
        hour: currentTime.hour + (currentTime.minute + 30) ~/ 60,
        minute: (currentTime.minute + 30) % 60,
      );
    }

    return slots;
  }

  TimeOfDay _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  double _timeToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }


  void selectSpecialization(String specialization) {
    selectedSpecialization.value = specialization;
    selectedDoctor.value = '';
  }


  Future<void> confirmBooking() async {
    try {
      isLoading.value = true;

      final appointment = AppointmentModel(
        id: DateTime
            .now()
            .millisecondsSinceEpoch
            .toString(),
        patientId: patientId??_firebaseService.currentUser!.uid,
        doctorId: selectedDoctorId.value,
        doctorName: selectedDoctorName.value,
        patientName: patientName,
        specialization: selectedSpecialization.value,
        dateTime: DateTime(
          selectedDate.value?.year??DateTime.january,
          selectedDate.value?.month??DateTime.january,
          selectedDate.value?.day??DateTime.monday,
          selectedTime.value?.hour??DateTime.monday,
          selectedTime.value?.minute??DateTime.monday,
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

  final RxList<DoctorModel> doctors = <DoctorModel>[].obs;

  // Fetch doctors for selected specialization
  Future<List<Map<String, dynamic>>> getDoctors() async {
    try {
      isLoadingDoctors.value = true;

      if (selectedSpecialization.value.isEmpty) {
        return [];
      }

      // Get doctors from Firebase
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('specialization', isEqualTo: selectedSpecialization.value)
          .where('isActive', isEqualTo: true) // Only get active doctors
          .get();

      // Transform the data
      final List<Map<String, dynamic>> doctorsList = querySnapshot.docs
          .map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return {
          'id': doc.id,
          'name': 'Dr. ${data['firstName']} ${data['lastName']}',
          'rating': data['rating'] ?? 0.0,
          'experience': data['experience'] ?? '0 years',
          'specialization': data['specialization'],
          'imageUrl': data['imageUrl'],
          'qualifications': data['qualifications'] ?? [],
          'availableDays': data['availableDays'] ?? [],
          'consultationFee': data['consultationFee'],
          'about': data['about'] ?? '',
        };
      })
          .toList();

      // Sort doctors by rating (highest first)
      doctorsList.sort((a, b) =>
          (b['rating'] as double).compareTo(a['rating'] as double));

      return doctorsList;
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to load doctors: ${e.toString()}'.tr,
      );
      return [];
    } finally {
      isLoadingDoctors.value = false;
    }
  }

  // Get count of doctors for a specialization
  Future<int> getDoctorCount(String specialization) async {
    try {
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('specialization', isEqualTo: specialization)
          .where('isActive', isEqualTo: true)
          .get();

      return querySnapshot.size;
    } catch (e) {
      print('Error getting doctor count: $e');
      return 0;
    }
  }

  // Check if a doctor is available on a specific date and time
  Future<bool> isDoctorAvailable(String doctorId, DateTime dateTime) async {
    try {
      // Check existing appointments
      final QuerySnapshot appointmentsQuery = await FirebaseFirestore.instance
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId)
          .where('dateTime', isEqualTo: dateTime)
          .get();

      // Return true if no appointments exist for this time slot
      return appointmentsQuery.docs.isEmpty;
    } catch (e) {
      print('Error checking doctor availability: $e');
      return false;
    }
  }

  // Get doctor's available time slots for a specific date
  Future<List<TimeOfDay>> getDoctorTimeSlots(String doctorId,
      DateTime date) async {
    try {
      // Get doctor's working hours from Firebase
      final DocumentSnapshot doctorDoc = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .get();

      if (!doctorDoc.exists) {
        return [];
      }

      final data = doctorDoc.data() as Map<String, dynamic>;
      final workingHours = data['workingHours'] ?? {};
      final dayOfWeek = DateFormat('EEEE').format(date).toLowerCase();

      if (!workingHours.containsKey(dayOfWeek)) {
        return [];
      }

      // Generate time slots based on working hours
      final List<TimeOfDay> slots = [];
      final startTime = TimeOfDay.fromDateTime(
          DateFormat.Hm().parse(workingHours[dayOfWeek]['start']));
      final endTime = TimeOfDay.fromDateTime(
          DateFormat.Hm().parse(workingHours[dayOfWeek]['end']));

      // Add slots every 30 minutes
      var currentSlot = startTime;
      while (_timeOfDayToDouble(currentSlot) <= _timeOfDayToDouble(endTime)) {
        // Check if this slot is already booked
        final slotDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          currentSlot.hour,
          currentSlot.minute,
        );

        final isAvailable = await isDoctorAvailable(doctorId, slotDateTime);
        if (isAvailable) {
          slots.add(currentSlot);
        }

        // Add 30 minutes
        final nextMinutes = currentSlot.minute + 30;
        currentSlot = TimeOfDay(
          hour: currentSlot.hour + nextMinutes ~/ 60,
          minute: nextMinutes % 60,
        );
      }

      return slots;
    } catch (e) {
      print('Error getting doctor time slots: $e');
      return [];
    }
  }


  double _timeOfDayToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }


  Future<void> fetchDoctorsBySpecialty(String specialty) async {
    try {
      isLoading.value = true;
      availableDoctors.value =
      await _firebaseService.getDoctorsBySpecialty(specialty);
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

    if (selectedDoctorId.value.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Please select a doctor'.tr,
      );
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
    update();
  }
}
