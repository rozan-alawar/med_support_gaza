import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLogin = true.obs;


  void toggleView() {
    isLogin.value = !isLogin.value;
  }
}
