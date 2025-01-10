import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_snackbar_widget.dart';

class DoctorAppointmentManagementController extends GetxController {
  var selectedDate = DateTime.now().obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var appointments = <Map<String, dynamic>> [
   

  ].obs;

  var periods = ['morning_period', 'evening_period'].obs;
  var selectedPeriod = 'morning_period'.obs;

  @override
  void onInit() {
    super.onInit();

    // Replace with actual doctorId
    String doctorId = 'sampleDoctorId';
    loadAppointments(doctorId);
  }

  void updatePeriod(String newPeriod) {
    selectedPeriod.value = newPeriod;
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
    String doctorId = await FirebaseAuth.instance.currentUser!.uid;
    print('doctor id : ${doctorId} ');
    try {
      // Format the date to a readable string
      String monthName = DateFormat.MMMM().format(selectedDate.value);
      String dayName = DateFormat.EEEE().format(selectedDate.value);
      String formattedDate =
          '${dayName.tr}   ${selectedDate.value.day}  ${monthName.tr}';

      // Initialize time variables
      TimeOfDay startTimeOfDay;
      TimeOfDay endTimeOfDay;

      if (selectedPeriod.value.tr == 'morning_period'.tr) {
        startTimeOfDay = const TimeOfDay(hour: 8, minute: 0);
        endTimeOfDay = const TimeOfDay(hour: 11, minute: 0);
      } else {
        startTimeOfDay = const TimeOfDay(hour: 12, minute: 0);
        endTimeOfDay = const TimeOfDay(hour: 15, minute: 0); // 3:00 PM
      }

      // Convert TimeOfDay to DateTime for processing
      DateTime baseDate = DateTime(
        selectedDate.value.year,
        selectedDate.value.month,
        selectedDate.value.day,
      );

      DateTime startTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        startTimeOfDay.hour,
        startTimeOfDay.minute,
      );

      DateTime endTime = DateTime(
        baseDate.year,
        baseDate.month,
        baseDate.day,
        endTimeOfDay.hour,
        endTimeOfDay.minute,
      );

      // Generate 30-minute session slots
      List<Map<String, dynamic>> sessions = [];
      DateTime currentSlot = startTime;

      while (currentSlot.isBefore(endTime)) {
        DateTime slotEnd = currentSlot.add(const Duration(minutes: 30));

        sessions.add({
          'date': Timestamp.fromDate(selectedDate.value),
          'startTime': DateFormat.jm().format(currentSlot),
          'endTime': DateFormat.jm().format(slotEnd),
          'period': selectedPeriod.value,
          'isBooked': false,
          'createdAt': FieldValue.serverTimestamp(),
        });

        currentSlot = slotEnd;
      }

      // Batch write to Firebase for better performance
      final batch = _firestore.batch();
      final appointmentsCollection = _firestore
          .collection('doctors')
          .doc(doctorId)
          .collection('availableAppointments');

      for (var session in sessions) {
        final docRef = appointmentsCollection.doc();
        batch.set(docRef, session);
      }

      await batch.commit();

      // Update local state
      appointments.add({
        'date': formattedDate,
        'period': selectedPeriod.value,
        'time': selectedPeriod.value.tr == 'morning_period'.tr
            ? 'morning_period_time'.tr
            : 'evening_period_time'.tr,
      });
      appointments.add({
        'date': formattedDate,
        'period': selectedPeriod.value,
        'time': selectedPeriod.value.tr == 'morning_period'.tr
            ? 'morning_period_time'.tr
            : 'evening_period_time'.tr,
      });
      
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

//   Future<void> addAppointment(String doctorId) async {
//     // Format the date to a readable string
//     String monthName = DateFormat.MMMM().format(selectedDate.value);
//     String dayName = DateFormat.EEEE().format(selectedDate.value);
//     String formattedDate =
//         '${dayName.tr}   ${selectedDate.value.day}  ${monthName.tr}';
//     String time;
//     String startTime, endTime;
//     if (selectedPeriod.value.tr == 'morning_period'.tr) {
//       time = 'morning_period_time'.tr;
//       startTime = '08:00 AM';
//       endTime = '11:00 AM';
//     } else {
//       time = 'evening_period_time'.tr;
//       startTime = '12:00 PM';
//       endTime = '03:00 PM';
//  }
//       print("Debug - Start Time: $startTime");
//       print("Debug - End Time: $endTime");
//       // تحويل النصوص الزمنية إلى DateTime
//       DateTime start = DateFormat.jm().parse(startTime);
//       DateTime end = DateFormat.jm().parse(endTime);

//       // إنشاء جلسات بفاصل زمني قدره 30 دقيقة
//       List<Map<String, dynamic>> sessions = [];
//       while (start.isBefore(end)) {
//         DateTime sessionEnd = start.add(const Duration(minutes: 30));
//         sessions.add({
//           'date': selectedDate.value,
//           'startTime': DateFormat.jm().format(start),
//           'endTime': DateFormat.jm().format(sessionEnd),
//           'period': selectedPeriod.value,
//           'isBooked': false, // تحديد الجلسة كغير محجوزة
//           'createdAt': FieldValue.serverTimestamp(),
//         });
//         start = sessionEnd;
//       }
//       // تخزين الجلسات في Firebase
//       for (var session in sessions) {
//         await _firestore
//             .collection('doctors')
//             .doc(doctorId)
//             .collection('availableAppointments')
//             .add(session);
//       }
//      CustomSnackBar.showCustomSnackBar(
//         title: 'Success',
//         message: 'Appointment add successfully',
//       );
//     appointments.add(
//         {'date': formattedDate, 'period': selectedPeriod.value, 'time': time});
//   }

  void deleteAppointment(int index) async {
    try {
      // Get the selected appointment details
      final appointmentToDelete = appointments[index];

      // Remove it from the local list
      appointments.removeAt(index);

      // Assuming you have the doctorId stored in your controller
      final String doctorId = FirebaseAuth.instance.currentUser?.uid ?? '';

      // Access Firestore and delete the specific appointment
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('availableAppointments')
          .where('date', isEqualTo: appointmentToDelete['date'])
          .where('period', isEqualTo: appointmentToDelete['period'])
          .where('time', isEqualTo: appointmentToDelete['time'])
          .get()
          .then((querySnapshot) {
        for (var doc in querySnapshot.docs) {
          doc.reference.delete();
        }
      });

      // Optional: Show success message
      CustomSnackBar.showCustomSnackBar(
        title: 'Success',
        message: 'Appointment deleted successfully',
      );
    } catch (e) {
      // Handle errors
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to delete appointment: $e',
      );
    }
  }

  void loadAppointments(String doctorId) async {
    try {
      // Fetch the appointments from Firestore
      final querySnapshot = await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('availableAppointments')
          .get();

      // Parse and update the local appointments list
      appointments.value = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'date': data['date']?.toString() ?? '', // Explicitly cast to String
          'period':
              data['period']?.toString() ?? '', // Explicitly cast to String
          'time': data['time']?.toString() ?? '', // Explicitly cast to String
        };
      }).toList();

      // Optional: Show a success message
      Get.snackbar('Success', 'Appointments loaded successfully',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      // Handle errors
      Get.snackbar('Error', 'Failed to load appointments: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
