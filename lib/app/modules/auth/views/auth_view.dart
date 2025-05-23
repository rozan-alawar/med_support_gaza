import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/auth/views/patient_login_view.dart';
import 'package:med_support_gaza/app/modules/auth/views/patient_signup_view.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
       child: controller.isLogin.value ? PatientLoginView() : PatientSignUpView(),
      )),
    );

  }
}
