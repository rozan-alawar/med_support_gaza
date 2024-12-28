import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final isLogin = true.obs;
  final isPasswordVisible = false.obs;
  final isLoading = false.obs;

  void toggleView() {
    isLogin.value = !isLogin.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

//-------------------------------------------------- Sign In -------------------------------------------
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      print('🚀 Sign In Request:');
      print('Email: $email');
      print('Password: ${password.replaceAll(RegExp(r'.'), '*')}');

      Timer(
        Duration(milliseconds: 500),
            () => Get.offAllNamed(Routes.HOME),
      );
    } on Exception catch (e) {
      isLoading.value = false;
      String message = 'حدث خطأ ما';
      print('\n❌ Sign In Error:');
      CustomSnackBar.showCustomErrorSnackBar(title: 'خطأ', message: message);
    } finally {
      isLoading.value = false;
    }
  }

//-------------------------------------------------- Sign Up -------------------------------------------

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String email,
    required String age,
    required String gender,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      print('🚀 Sign Up Request:');
      print('Name: $firstName $lastName');
      print('Email: $email');
      print('Password: ${password.replaceAll(RegExp(r'.'), '*')}');

      CustomSnackBar.showCustomErrorSnackBar(

          message: 'تم انشاء حساب جديد', color: Colors.green, title: 'نجاح');

      Timer(
        Duration(milliseconds: 500),
            () => toggleView,
      );
    } on Exception catch (e) {
      isLoading.value = false;

      String message = 'حدث خطأ ما';

      print('\n❌ Sign Up Error:');

      CustomSnackBar.showCustomErrorSnackBar(title: 'خطأ', message: message);
    } finally {
      isLoading.value = false;
    }
  }

//---------------------------------------------- Forget Password -------------------------------------------

  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading.value = true;
      print('🚀 Reset Password Request for: $email');
      isLoading.value = false;
      Timer(
        Duration(milliseconds: 500),
            () => Get.toNamed(Routes.NEW_PASSWORD),
      );
    } on Exception catch (e) {
      isLoading.value = false;

      String message = 'حدث خطأ ما';

      print('\n❌ Reset Password Error:');

      CustomSnackBar.showCustomErrorSnackBar(title: 'خطأ', message: message);
    } finally {
      isLoading.value = false;
    }
  }
}
