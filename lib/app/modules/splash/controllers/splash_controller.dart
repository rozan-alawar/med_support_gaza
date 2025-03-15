import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
       // Get.offNamed(Routes.DOCTOR_HOME);
     // Get.offNamed(Routes.User_Role_Selection);
      checkLoginStatus();

    });
  }
  void checkLoginStatus() {
    bool isLoggedIn = CacheHelper.getData(key: 'isLoggedIn') ?? false;
    String? userType = CacheHelper.getData(key: 'userType');

    if (isLoggedIn) {
      if (userType == 'admin') {
        Get.offAllNamed(Routes.ADMIN_HOME);
      } else if (userType == 'patient') {
        Get.offAllNamed(Routes.HOME);
      }  else if (userType == 'doctor') {
        Get.offAllNamed(Routes.DOCTOR_HOME);
      }
    } else {
      Get.offAllNamed(Routes.User_Role_Selection);
    }
  }
}
