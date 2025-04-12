import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/cache_helper.dart';
import '../../../core/utils/app_colors.dart';
import '../../../data/api_services/doctor_appointment_api.dart';
import '../../../data/firebase_services/chat_services.dart';
import '../../../data/models/appointment.dart';
import '../../../data/models/consultation_model.dart';
import '../../../routes/app_pages.dart';

class DoctorAppointmentManagementController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var selectedTime = '09:00 AM'.obs;
  var endTime = '09:30 AM'.obs;
  var availableTimes = <String>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ChatService _chatService = ChatService();

  RxList<Appointment> appointments = <Appointment>[].obs;
  RxList<ConsultationModel> PandingAppointments = <ConsultationModel>[].obs;
  RxList<ConsultationModel> dayilyAppointments = <ConsultationModel>[].obs;
  RxBool isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Replace with actual doctorId
    // final String doctorId = FirebaseAuth.instance.currentUser?.uid ?? '';
    getPandingAppointment();
    getDayilyappointment();
    loadAvailableAppointments();
    generateAvailableTimes();
  }

  void generateAvailableTimes() {
    availableTimes.clear();

    // Create times from 9 AM to 4 PM
    for (int hour = 9; hour <= 16; hour++) {
      // For each hour, create :00 and :30 slots
      String period = hour < 12 ? 'AM' : 'PM';
      int displayHour = hour > 12 ? hour - 12 : hour;

      // Add XX:00 slot
      availableTimes
          .add('${displayHour.toString().padLeft(2, '0')}:00 $period');

      // Add XX:30 slot if not the last hour
      if (hour != 16) {
        availableTimes
            .add('${displayHour.toString().padLeft(2, '0')}:30 $period');
      }
    }
  }

  void updateSelectedTime(String time) {
    selectedTime.value = time;
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.value,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate.value) {
      selectedDate.value = picked;
    }
  }

  Future<void> addAppointment() async {
    try {
      print(' addAppointment :  $appointments');

      print(selectedDate.value);
      String date = dateFormate(selectedDate.value);
      String? token = CacheHelper.getData(key: 'token');
      if (token == null) {
        Get.toNamed(Routes.DOCTOR_LOGIN);
        return;
      }
      setEndTime();
      isloading.value = true;
      final response = await Get.find<DoctorAppointmentAPI>()
          .addDoctorAppointment(
              token: token,
              date: date,
              startTime: selectedTime.value,
              endTime: endTime.value);
      if (response.data != null) {
        Appointment appointment =
            Appointment.fromJson(response.data['appointment']);
        loadAvailableAppointments();
      }
      print(' addAppointment :  $appointments');

      // getDayilyappointment();
    } catch (e) {
      isloading.value = false;
      print(e.toString());
    } finally {
      isloading.value = false;
    }
  }

  void setEndTime() {
    // Calculate the end time based on the selected time ( the end time is half hour after the start time)
    List<String> timeSplit = selectedTime.value.split(':');
    int hour = int.parse(timeSplit[0]);
    int minute = int.parse(timeSplit[1].split(' ')[0]);
    String period = timeSplit[1].split(' ')[1].trim();
    minute += 30;
    if (minute >= 60) {
      hour += 1;
      minute -= 60;
    }
    if (hour == 12) {
      period = 'PM';
    }

    endTime.value =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  void deleteAppointment(int index) async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }
    try {
      await Get.find<DoctorAppointmentAPI>()
          .delelteDoctorAppointment(token: token, id: appointments[index].id);
      loadAvailableAppointments();
    } catch (e) {
      print(e.toString());
    }
  }

  void loadAvailableAppointments() async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }
    try {
      appointments.clear();
      final response = await Get.find<DoctorAppointmentAPI>()
          .getDoctorAppointments(token: token, status: 'Available');
      DateTime now = DateTime.now();
      appointments.value = AppointmentModel.fromJson(response.data)
          .appointments
          .where((element) {
        bool isAfter = element.date.isAfter(DateTime(
          now.year,
          now.month,
          now.day,
        ));
        bool isSameDay = element.date == DateTime(now.year, now.month, now.day)
            ? true
            : false;
        if (isAfter) {
          return true;
        }
        if (isSameDay) {
          // startTime is in the format "HH:mm AM/PM" it need to modifiy to 24- formate
          // Convert "HH:mm AM/PM" to 24-hour format
          final timeParts = element.startTime.split(':');
          int hour = int.parse(timeParts[0].trim());
          int minute = int.parse(timeParts[1].split(' ')[0].trim());
          String period = timeParts[1].split(' ')[1].trim(); // AM or PM
          if (period == "PM" && hour != 12) {
            hour += 12;
          } else if (period == "AM" && hour == 12) {
            hour = 0;
          }
          final appointmentTime = DateTime(now.year, now.month, now.day, hour);
          return appointmentTime.isAfter(DateTime.now());
        }
        return false;
      }).toList();
    } catch (e) {
      print(e.toString());
    }
  }

  void getPandingAppointment() async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }
    try {
      PandingAppointments.clear();
      final consultationsStream = await _chatService.getDoctorConsultations(
          CacheHelper.getData(key: 'id'), 'upcoming');
      DateTime now = DateTime.now();
      await for (var consultations in consultationsStream) {
        for (var consultation in consultations) {
          DateTime consultationDate = consultation.startTime.toDate();
          if (consultationDate
              .isAfter(DateTime(now.year, now.month, now.day, now.minute))) {
            PandingAppointments.add(consultation);
          }
        }
      }
      PandingAppointments.sort((a, b) => (a.startTime).compareTo(b.startTime));
      print(" PandingAppointments.length: ${PandingAppointments.length}");
    } catch (e) {
      print(e.toString());
    }
  }

  void approveBooking(int index) async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }
    try {
      // final response = await Get.find<DoctorAppointmentAPI>().acceptAppointment(
      //     token: token, id: int.parse(PandingAppointments[index].id));
      await _chatService.updateConsultationStatusByDoctor(
          '${PandingAppointments[index].id}', 'upcoming');
      getPandingAppointment();
    } catch (e) {
      print(e.toString());
    }
  }

  void rejectBooking(int index) async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }
    try {
      await _chatService.updateConsultationStatusByDoctor(
          '${PandingAppointments[index].id}', 'canceled');
           getPandingAppointment();
      // final response = await Get.find<DoctorAppointmentAPI>().rejectAppointment(
      //     token: token, id: int.parse(PandingAppointments[index].id));
    } catch (e) {
      print(e.toString());
    }
  }

  // Helper functions
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String getFormatedDate(DateTime selectedDate) {
    String monthName = DateFormat.MMMM().format(selectedDate);
    String dayName = DateFormat.EEEE().format(selectedDate);
    String formattedDate =
        '${dayName.tr}   ${selectedDate.day}  ${monthName.tr}';
    return formattedDate;
  }

  String dateFormate(DateTime dateTime) {
    String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
    return formattedDate;
  }

  // get the daily appointment that is booking from a appointments list due to the date

  void getDayilyappointment() async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }

    try {
      dayilyAppointments.clear();
      final consultationsStream = _chatService.getDoctorConsultations(
          CacheHelper.getData(key: 'id'), 'upcoming');

      await for (var consultations in consultationsStream) {
        for (var consultation in consultations) {
          DateTime consultationDate = consultation.startTime.toDate();
          if (isSameDay(consultationDate, selectedDate.value)) {
            dayilyAppointments.add(consultation);
          }
        }
      }
      // Sort daily appointments by time
      dayilyAppointments.sort((a, b) => (a.startTime).compareTo(b.startTime));
    } catch (e) {
      print(e.toString());
    }
  }

  void cancelAppointment(int index) async {
    String? token = CacheHelper.getData(key: 'token');

    if (token == null) {
      Get.toNamed(Routes.DOCTOR_LOGIN);
      return;
    }
    try {
      //int id = int.parse(dayilyAppointments[index].id);
      // await Get.find<DoctorAppointmentAPI>()
      //     .delelteDoctorAppointment(token: token, id: id);
      await _chatService.updateConsultationStatusByDoctor(
          dayilyAppointments[index].id, 'canceled');
      getDayilyappointment();
    } catch (e) {
      print(e.toString());
    }
  }

  String? fomatTime(Timestamp? timestamp) {
    if (timestamp == null) return null;
    return DateFormat('hh:mm a').format(timestamp.toDate());
  }
}
