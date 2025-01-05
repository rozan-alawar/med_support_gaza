import 'package:get/get.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final RxInt currentIndex = 3.obs;


  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
    update();
      currentIndex.value = index;
    switch (index) {
      case 0: // Home
        Get.offAllNamed(Routes.HOME);
        break;
      case 1: // Doctors
        Get.toNamed(Routes.PROFILE);
        break;
      case 2: // Chat
        Get.toNamed(Routes.HOME);
        break;
      case 3: // Profile
        Get.toNamed(Routes.PROFILE);
        break;
    }
  }
}