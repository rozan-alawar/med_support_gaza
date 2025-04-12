import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/api_services/patient_appointment_api.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/data/models/specialization_model.dart';
import 'package:med_support_gaza/app/data/models/specializations_response.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/auth_controller.dart';
import 'package:med_support_gaza/app/modules/home/controllers/home_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AppointmentBookingController extends GetxController {
  final RxInt currentStep = 0.obs;
  Rxn<Specialization> selectedSpecialization = Rxn<Specialization>();
  Rx<Doctor>? selectedDoctor;
  final selectedDate = Rx<DateTime?>(null);
  final Rxn<TimeOfDay> selectedTime = Rxn<TimeOfDay>();
  final RxBool isLoading = false.obs;
  final RxString selectedDoctorId = ''.obs;
  final RxString selectedDoctorName = ''.obs;
  final RxList<Specialization> specializations = <Specialization>[].obs;
  final RxString error = ''.obs;

  final RxList<Doctor> availableDoctors = <Doctor>[].obs;
  RxList<Doctor> doctorsList = <Doctor>[].obs;

  final RxBool isLoadingDoctors = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  final RxBool isDirectBooking = false.obs;
  final ChatService _chatService = ChatService();

  @override
  void onInit() {
    super.onInit();
    getDoctorsSpecializations();
    // Check if we're booking with a specific doctor
    final arguments = Get.arguments;
    if (arguments != null && arguments['doctor'] != null) {
      isDirectBooking.value = true;
      final Doctor doctor = arguments['doctor'];
      selectedSpecialization.value?.major = doctor.major ?? "null";
      selectDoctor(doctor);
      // Skip to time selection step
      currentStep.value = 2;
    }
  }

  // Patient data from auth



//------------------------ GET DOCTORS SPECIALIZATIONS -----------------------------

  void getDoctorsSpecializations() {
    PatientAppointmentAPIService.getDoctorsSpecializations(
      onSuccess: (response) {
        isLoading.value = false;
        final data = response.data;
        final specializationsResponse = SpecializationsResponse.fromJson(data);
        specializations.value = specializationsResponse.specializations;
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

//------------------------ GET DOCTORS BY SPECIALIZATIONS -----------------------------

  void getDoctorsBySpecializations() {
    if (selectedSpecialization.value == null) return;

    PatientAppointmentAPIService.getDoctorsBySpecialization(
      specialization: selectedSpecialization.value?.major ?? "Null",
      onSuccess: (response) {
        isLoading.value = false;
        final data = response.data['doctors'] as List;
        doctorsList.value = data
            .map((item) => Doctor.fromJson(item as Map<String, dynamic>))
            .toList();
        availableDoctors.value = doctorsList;
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }
  //
  // Future<void> loadDoctors() async {
  //   if (selectedSpecialization?.value == null) return;
  //
  //   try {
  //     isLoadingDoctors.value = true;
  //     hasError.value = false;
  //     errorMessage.value = '';
  //
  //     // Query Firestore for doctors
  //     final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('doctors')
  //         .where('speciality', isEqualTo: selectedSpecialization?.value)
  //         .where('isApproved', isEqualTo: true)
  //         .get();
  //
  //     // Convert to DoctorModel list
  //     final List<Doctor> doctors = querySnapshot.docs
  //         .map((doc) => Doctor.fromJson(doc.data() as Map<String, dynamic>))
  //         .toList();
  //     print(doctors);
  //     print(doctors.first.firstName);
  //
  //     // Sort by rating
  //     // doctors.sort((a, b) => b.rating.compareTo(a.rating));
  //
  //     availableDoctors.value = doctors;
  //     availableDoctors.add(Doctor(
  //         id: 5,
  //         userId: 5,
  //         firstName: "Mohammed",
  //         lastName: "Nour",
  //         email: "m@gmail.com",
  //         major: "major",
  //         country: "IT",
  //         phoneNumber: "054865312",
  //         averageRating: "4.5",
  //         image: "image",
  //         certificate: "certificate",
  //         gender: "Male"));
  //   } catch (e) {
  //     hasError.value = true;
  //     errorMessage.value = e.toString();
  //     availableDoctors.clear();
  //   } finally {
  //     isLoadingDoctors.value = false;
  //   }
  // }

  void selectDoctor(Doctor doctor) {
    selectedDoctorId.value = doctor.id.toString();
    selectedDoctor = doctor.obs;
    selectedDoctorName.value = "${doctor.firstName} ${doctor.lastName}";

    print(selectedDoctor);
    // Reset time selection when doctor changes
    selectedTime.value = null;
    selectedDate.value = null;
  }

  void nextStep() {
    if (isDirectBooking.value) {
      // Skip specialization and doctor selection steps
      if (currentStep.value < 2) {
        currentStep.value = 2;
      } else if (currentStep.value == 2) {
        // Validate time selection
        if (selectedTime.value == null) {
          CustomSnackBar.showCustomErrorSnackBar(
            title: 'Error'.tr,
            message: 'Please select a time slot'.tr,
          );
          return;
        }
        currentStep.value = 3;
      } else {
        confirmBooking();
      }
    } else {
      if (currentStep.value == 0 && selectedSpecialization.value == null) {
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

      if (currentStep.value == 2 &&
          (selectedDate.value == null || selectedTime.value == null)) {
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
  }

  List<TimeOfDay> getAvailableTimeSlots(Doctor doctor, DateTime date) {
    final dayOfWeek = date.weekday; // 1 = Monday, 7 = Sunday

    // Find working hours for selected day
    final workingHours = WorkingHours(
        dayOfWeek: dayOfWeek,
        startTime: '09:00',
        endTime: '17:00',
        isAvailable: false);

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

  void selectSpecialization(Specialization specialization) {
    selectedSpecialization.value = specialization;
    getDoctorsBySpecializations();
    selectedDoctorName.value = '';
  }

  Future<void> confirmBooking() async {
    isLoading.value = true;

    // final appointment = AppointmentModel(
    //   id: DateTime.now().millisecondsSinceEpoch.toString(),
    //   patientId: HomeController().currentUser.value!.id.toString() ?? "mkcjhdk",
    //   doctorId: selectedDoctorId.value,
    //   doctorName: selectedDoctorName.value,
    //   patientName: patientName,
    //   specialization: selectedSpecialization.value?.major ?? "Null",
    //   // dateTime: DateTime(
    //   //   selectedDate.value?.year ?? DateTime.january,
    //   //   selectedDate.value?.month ?? DateTime.january,
    //   //   selectedDate.value?.day ?? DateTime.monday,
    //   //   selectedTime.value?.hour ?? DateTime.monday,
    //   //   selectedTime.value?.minute ?? DateTime.monday,
    //   // ),
    //   dateTime: selectedDate.value ?? DateTime.now(),
    // );
    await _chatService.bookAppointment(
      doctor: selectedDoctor!.value,
      patient: HomeController().currentUser.value!,
      date: selectedDate.value!,
      endTime: addMinutesToTimestamp(
          convertTimeOfDayToTimestamp(selectedDate.value!,selectedTime.value!), 30),
      startTime: convertTimeOfDayToTimestamp(selectedDate.value!,selectedTime.value!),
    );

    CustomSnackBar.showCustomSnackBar(
      title: 'Success'.tr,
      message: 'Appointment booked successfully'.tr,
    );

    Get.offNamed(Routes.HOME);
  }

  Timestamp convertTimeOfDayToTimestamp(DateTime selectedDate,TimeOfDay timeOfDay) {
    DateTime date = selectedDate;
    DateTime dateTime = DateTime(
        date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute);
    return Timestamp.fromDate(dateTime);
  }

  Timestamp addMinutesToTimestamp(Timestamp timestamp, int minutes) {
    DateTime dateTime = timestamp.toDate();
    DateTime newDateTime = dateTime.add(Duration(minutes: minutes));
    return Timestamp.fromDate(newDateTime);
  }

  final List<String> stepTitles = [
    'SelectSpecialization',
    'SelectDoctor',
    'ChooseTime',
    'ConfirmBooking'
  ];

  final RxList<DoctorModel> doctors = <DoctorModel>[].obs;

  // Fetch doctors for selected specialization
  Future<List<Map<String, dynamic>>> getDoctors() async {
    try {
      isLoadingDoctors.value = true;

      if (selectedSpecialization.value == null) {
        return [];
      }

      // Get doctors from Firebase
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .where('specialization', isEqualTo: selectedSpecialization.value)
          .where('isActive', isEqualTo: true) // Only get active doctors
          .get();

      // Transform the data
      final List<Map<String, dynamic>> doctorsList =
          querySnapshot.docs.map((doc) {
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
      }).toList();

      // Sort doctors by rating (highest first)
      doctorsList.sort(
          (a, b) => (b['rating'] as double).compareTo(a['rating'] as double));

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
  Future<List<TimeOfDay>> getDoctorTimeSlots(
      String doctorId, DateTime date) async {
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



  bool validateBooking() {


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

// Update the existing getAvailableTimes method to consider the selected date
  List<TimeOfDay> getAvailableTimes() {
    // If no date is selected, return empty list
    if (selectedDate.value == null) {
      return [];
    }

    // Check if the selected date is today
    final now = DateTime.now();
    final isToday = selectedDate.value!.year == now.year &&
        selectedDate.value!.month == now.month &&
        selectedDate.value!.day == now.day;

    // Base available times
    final availableTimes = [
      const TimeOfDay(hour: 9, minute: 0),
      const TimeOfDay(hour: 9, minute: 30),
      const TimeOfDay(hour: 10, minute: 0),
      const TimeOfDay(hour: 10, minute: 30),
      const TimeOfDay(hour: 11, minute: 0),
      const TimeOfDay(hour: 11, minute: 30),
      const TimeOfDay(hour: 13, minute: 30),
      const TimeOfDay(hour: 13, minute: 0),
      const TimeOfDay(hour: 14, minute: 0),
      const TimeOfDay(hour: 14, minute: 30),
      const TimeOfDay(hour: 15, minute: 0),
      const TimeOfDay(hour: 15, minute: 30),
      const TimeOfDay(hour: 16, minute: 0),
      const TimeOfDay(hour: 16, minute: 30),
    ];

    if (isToday) {
      final currentTime = TimeOfDay.fromDateTime(now);
      return availableTimes.where((time) {
        return time.hour > currentTime.hour ||
            (time.hour == currentTime.hour && time.minute > currentTime.minute);
      }).toList();
    }

    // Check if the selected date is a weekend (optional)
    final dayOfWeek = selectedDate.value!.weekday;
    if (dayOfWeek == DateTime.saturday || dayOfWeek == DateTime.sunday) {
      return availableTimes
          .where((time) => time.hour >= 10 && time.hour < 15)
          .toList();
    }

    return availableTimes;
  }

// Add this method to select a date
  void selectDate(DateTime date) {
    selectedDate.value = date;
    selectedTime.value = null;
    update();
  }

  String getFormattedDateTime() {
    if (selectedDate.value == null || selectedTime.value == null) {
      return 'Not selected'.tr;
    }

    final date = selectedDate.value!;
    final time = selectedTime.value!;

    final dateFormat = DateFormat('EEE, MMM d, yyyy');
    final formattedDate = dateFormat.format(date);

    return '$formattedDate at ${time.format(Get.context!)}';
  }
}
