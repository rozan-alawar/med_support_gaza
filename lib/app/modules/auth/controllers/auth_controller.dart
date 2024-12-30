import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AuthController extends GetxController {
  final isLogin = true.obs;
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;

  final RxList<String> otpDigits = List.generate(4, (index) => '').obs;
  final RxInt timeRemaining = 15.obs;
  final RxBool canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
  }

  //-------------------------------------- OTP Timer -------------------------------------
  void startTimer() {
    timeRemaining.value = 15;
    canResend.value = false;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (timeRemaining.value == 0) {
        canResend.value = true;
        return false;
      }
      timeRemaining.value--;
      return true;
    });
  }

  void setDigit(int index, String value) {
    if (value.length <= 1) {
      otpDigits[index] = value;
    }
  }

  void resendOTP() {
    // Clear OTP
    for (var i = 0; i < otpDigits.length; i++) {
      otpDigits[i] = '';
    }
    startTimer();
    // Add your API call here to resend OTP
  }
  Future<void> verifyOTP() async {
    try {
      final otp = otpDigits.join();
      if (otp.length != 4) {
       CustomSnackBar.showCustomErrorSnackBar(
        title:   'Error'.tr,
        message:   'PleaseEnterCompleteOTP'.tr,
        );
        return;
      }


      Timer(
        Duration(seconds: 3),
            () => Get.offAllNamed(Routes.NEW_PASSWORD),
      );


    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Verification failed',
      );
    }
  }


//-------------------------------------------------------------------------------------
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
      print('🚀 Sign In Request: ${isLoading.value}');

      print('🚀 Sign In Request:');
      print('Email: $email');
      print('Password: ${password.replaceAll(RegExp(r'.'), '*')}');

      Timer(
        Duration(seconds: 3),
        () => Get.offAllNamed(Routes.HOME),
      );
      isLoading.value = false;
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
        () => Get.toNamed(Routes.VERIFICATION),
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
