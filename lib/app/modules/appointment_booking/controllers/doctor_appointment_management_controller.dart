import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_snackbar_widget.dart';

class DoctorAppointmentManagementController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var selectedTime = '09:00 AM'.obs;
  var availableTimes = <String>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var appointments = <Map<String, dynamic>> [
  ].obs;

  var dayilyappointments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Replace with actual doctorId
    final String doctorId = FirebaseAuth.instance.currentUser?.uid ?? '';
    loadAppointments();
    generateAvailableTimes();
    getDayilyappointment();
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
      appointments.add({
        'date': selectedDate.value,
        'startTime': selectedTime.value,
        'isBooked': true, // تحديد الجلسة كغير محجوزة
        'createdAt': FieldValue.serverTimestamp(),
        'patientName': 'Saja HZ',
        'patientid': '',
        'doctorId': '',
      });
      print(' addAppointment :  $appointments');

      getDayilyappointment();
      CustomSnackBar.showCustomSnackBar(
        title: 'Success',
        message: 'Appointments added successfully',
      );
    } catch (e) {
      print(e.toString());
      CustomSnackBar.showCustomSnackBar(
        title: 'Error',
        message: 'Failed to add appointments: ${e.toString()}',
      );
    }
  }

  void deleteAppointment(int index) async {
    appointments.removeAt(index);
    getDayilyappointment();
  }

  void loadAppointments() async {}

// get the daily appointment that is booking from a appointments list due to the date

  void getDayilyappointment() {
    try {
      // Clear current daily appointments
      dayilyappointments.clear();

      // Filter appointments for selected date
      for (var appointment in appointments) {
        DateTime appointmentDate = (appointment['date'] as DateTime);
        print(
            '-------------------- $appointmentDate--------------------------');
        if (isSameDay(appointmentDate, selectedDate.value) &&
            appointment['isBooked'] == true) {
          // Convert appointment time format if needed
          dayilyappointments.add({
            'patientName': appointment['patientName'],
            'patientid': appointment['patientid'],
            'date': appointment['date'],
            'startTime': appointment['startTime'],
            'isBooked': appointment['isBooked'],
            'status': appointment['status'],
            'createdAt': appointment['createdAt'],
          });
        }
        // Sort daily appointments by time
        dayilyappointments.sort(
            (a, b) => (a['startTime'] ?? '').compareTo(b['startTime'] ?? ''));
      }
    } catch (e) {
      CustomSnackBar.showCustomSnackBar(
        title: 'Error',
        message: 'Failed to load daily appointments: ${e.toString()}',
      );
    }
  }

  void approveBooking(int index) {}

  void rejectBooking(int index) {}

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
}
