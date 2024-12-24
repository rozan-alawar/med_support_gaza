import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // Navigate after delay
    Future.delayed( const Duration(seconds: 3), () {
      Get.offNamed('/home');
    });
  }
}
