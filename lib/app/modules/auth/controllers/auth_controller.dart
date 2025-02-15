import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_handler.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AuthController extends GetxController {
  static const int otpLength = 4;
  static const int otpTimerDuration = 15;

  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  Timer? _otpTimer;

  // Observable variables
  final RxBool isLogin = true.obs;
  final RxBool isPasswordVisible = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<PatientModel?> patientData = Rx<PatientModel?>(null);

  // OTP Related
  final RxList<String> otpDigits = List.generate(otpLength, (index) => '').obs;
  final RxInt timeRemaining = otpTimerDuration.obs;
  final RxBool canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeAuth();
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    super.onClose();
  }

  void _initializeAuth() {
    startTimer();
    currentUser.bindStream(_firebaseService.authStateChanges);
    ever(currentUser, _handleAuthChanged);
  }

  void toggleView() => isLogin.value = !isLogin.value;

  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  Future<void> _handleAuthChanged(User? user) async {
    if (user != null) {
      try {
        patientData.value = await _firebaseService.getPatientData(user.uid);
      } catch (e) {
        _handleError('Error'.tr, e.toString());
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
      hasError.value = false;
      
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

      _showSuccessMessage('AccountCreatedSuccessfully'.tr);
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      hasError.value = true;
      _handleError('Error'.tr, FirebaseErrorHandler.getErrorMessage(e.toString()));
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
      hasError.value = false;

      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      hasError.value = true;
      _handleError('Error'.tr, FirebaseErrorHandler.getErrorMessage(e.toString()));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      await _firebaseService.sendPasswordResetEmail(email);
      Get.toNamed(Routes.VERIFICATION);
    } catch (e) {
      hasError.value = true;
      _handleError('Error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void startTimer() {
    _otpTimer?.cancel();
    timeRemaining.value = otpTimerDuration;
    canResend.value = false;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        timeRemaining.value--;
      }
    });
  }

  void setDigit(int index, String value) {
    if (value.length <= 1 && index < otpLength) {
      otpDigits[index] = value;
    }
  }

  void resendOTP() {
    otpDigits.assignAll(List.generate(otpLength, (index) => ''));
    startTimer();
  }

  Future<void> verifyOTP() async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final otp = otpDigits.join();
      if (otp.length != otpLength) {
        throw 'PleaseEnterCompleteOTP'.tr;
      }

      // Add your OTP verification logic here
      
      Get.offAllNamed(Routes.NEW_PASSWORD);
    } catch (e) {
      hasError.value = true;
      _handleError('Error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String title, String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: title,
      message: message,
    );
  }

  void _showSuccessMessage(String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      message: message,
      color: Colors.green,
      title: 'Success'.tr,
    );
  }
}