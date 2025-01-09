import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigate after delay
    Future.delayed(const Duration(seconds: 3), () {
       // Get.offNamed(Routes.DOCTOR_LOGIN);
     Get.offNamed(Routes.User_Role_Selection);
    });
  }
}
