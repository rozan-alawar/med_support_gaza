import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final isLogin = true.obs;
  final isPasswordVisible = false.obs;





  void toggleView() {
    isLogin.value = !isLogin.value;
  }


  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void signUp() {
    print('User signed up');
  }
}
