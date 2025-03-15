import 'package:get/get.dart';

import '../../../data/models/appointment.dart';
import '../../appointment_booking/controllers/doctor_appointment_management_controller.dart';

class DoctorHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
  }


  var unreadMessages = 6.obs;
}
