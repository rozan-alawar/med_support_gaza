import 'package:get/get.dart';

class DoctorAppointmentManagementController extends GetxController {
  var morningSelected = true.obs;
  var eveningSelected = true.obs;
  var appointments = [
    {'date': 'NOV 12', 'period': 'الفترة الصباحية', 'time': 'من 6:00 AM إلى 10:00 AM'},
    {'date': 'NOV 12', 'period': 'الفترة الصباحية', 'time': 'من 6:00 AM إلى 10:00 AM'},
    {'date': 'NOV 12', 'period': 'الفترة الصباحية', 'time': 'من 6:00 AM إلى 10:00 AM'},
    {'date': 'NOV 12', 'period': 'الفترة الصباحية', 'time': 'من 6:00 AM إلى 10:00 AM'},
  ].obs;

  void toggleMorning() {
    morningSelected.value = !morningSelected.value;
  }

  void toggleEvening() {
    eveningSelected.value = !eveningSelected.value;
  }

  void addAppointment() {
    appointments.add({'date': 'NOV 12', 'period': 'الفترة الصباحية', 'time': 'من 6:00 AM إلى 10:00 AM'});
  }

  void deleteAppointment(int index) {
    appointments.removeAt(index);
  }
}