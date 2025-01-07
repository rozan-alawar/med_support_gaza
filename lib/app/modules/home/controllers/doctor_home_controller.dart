import 'package:get/get.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class DoctorHomeController extends GetxController {

  final RxInt currentIndex = 0.obs;


  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
    update();
      currentIndex.value = index;
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.DOCTOR_HOME);
        break;
      case 1: // Chat
        Get.toNamed(Routes.DOCTOR_CONSULTATION);
        break;
      case 2: // Appointment
        Get.toNamed(Routes.DOCTOR_APPOINTMENT_MANAGEMENT);
        break;
      case 3: // Profile
        Get.toNamed(Routes.DOCTOR_PROFILE);
        break;
    }
  }
}