import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/utils/app_colors.dart';

class DoctorAppointmentManagementController extends GetxController {
  var selectedDate = DateTime.now().obs;
  var appointments = [
    {
      'date': 'NOV 12',
      'period': 'الفترة الصباحية',
      'time': 'من 6:00 AM إلى 10:00 AM'
    },
    {
      'date': 'NOV 12',
      'period': 'الفترة الصباحية',
      'time': 'من 6:00 AM إلى 10:00 AM'
    },
    {
      'date': 'NOV 12',
      'period': 'الفترة الصباحية',
      'time': 'من 6:00 AM إلى 10:00 AM'
    },
    {
      'date': 'NOV 12',
      'period': 'الفترة الصباحية',
      'time': 'من 6:00 AM إلى 10:00 AM'
    },
  ].obs;

  var periods = ['morning_period', 'evening_period'].obs;
  var selectedPeriod = 'morning_period'.obs;

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

  void addAppointment() {
    // Format the date to a readable string
    String monthName = DateFormat.MMMM().format(selectedDate.value);
    String dayName = DateFormat.EEEE().format(selectedDate.value);
    String formattedDate =
        '${dayName.tr}   ${selectedDate.value.day}  ${monthName.tr}';
    String time;
    if (selectedPeriod.value.tr == 'morning_period'.tr) {
      time = 'morning_period_time'.tr;
    } else {
      time = 'evening_period_time'.tr;
    }
    appointments.add(
        {'date': formattedDate, 'period': selectedPeriod.value, 'time': time});
  }

  void deleteAppointment(int index) {
    appointments.removeAt(index);
  }
}
