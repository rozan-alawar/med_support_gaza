import 'package:get/get.dart';

class DoctorHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
  }

  var appointments = [
    {'patientName': 'المريض أحمد أحمد', 'date': 'NOV 12', 'time': '10:00 AM'},
    {'patientName': 'المريض محمد محمد', 'date': 'NOV 12', 'time': '11:00 AM'},
    {'patientName': 'المريض محمد محمد', 'date': 'NOV 12', 'time': '11:00 AM'},
  ].obs;

  var unreadMessages = 6.obs;
}
