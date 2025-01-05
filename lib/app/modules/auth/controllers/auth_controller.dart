import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';



class AuthController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  
  final isLogin = true.obs;
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<PatientModel?> patientData = Rx<PatientModel?>(null);

  // OTP Related
  final RxList<String> otpDigits = List.generate(4, (index) => '').obs;
  final RxInt timeRemaining = 15.obs;
  final RxBool canResend = false.obs;
 
 void toggleView() {
    isLogin.value = !isLogin.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    startTimer();
    // Listen to auth state changes
    currentUser.bindStream(_firebaseService.authStateChanges);
    ever(currentUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      // Fetch user data from Firestore
      try {
        patientData.value = await _firebaseService.getPatientData(user.uid);
      } catch (e) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.toString(),
        );
      }
    } else {
      patientData.value = null;
    }
  }

  Future<void> signUp({
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String email,
    required String age,
    required String gender,
    required String country,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      
      final patient = PatientModel(
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNo: phoneNo,
        age: age,
        gender: gender,
        country: country,
      );

      await _firebaseService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        patient: patient,
      );

      CustomSnackBar.showCustomErrorSnackBar(
        message: 'AccountCreatedSuccessfully'.tr,
        color: Colors.green,
        title: 'Success'.tr,
      );

      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading.value = true;
      await _firebaseService.sendPasswordResetEmail(email);
      Get.toNamed(Routes.VERIFICATION);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Your existing OTP methods remain the same
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
    for (var i = 0; i < otpDigits.length; i++) {
      otpDigits[i] = '';
    }
    startTimer();
  }

  Future<void> verifyOTP() async {
    try {
      final otp = otpDigits.join();
      if (otp.length != 4) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: 'PleaseEnterCompleteOTP'.tr,
        );
        return;
      }
      Get.offAllNamed(Routes.NEW_PASSWORD);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Verification failed',
      );
    }
  }
}