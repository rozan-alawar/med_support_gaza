import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../routes/app_pages.dart';

/// Controller responsible for handling doctor authentication related operations
class DoctorAuthController extends GetxController {
  // Constants
  static const int otpLength = 4;
  static const int otpResendDelay = 15;
  static const List<String> allowedFileExtensions = ['pdf', 'doc', 'docx'];
  
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // State management
  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxString selectedFilePath = ''.obs;
  final RxBool isFileUploading = false.obs;
  
  // OTP related state
  final RxList<String> otpDigits = List.generate(otpLength, (index) => '').obs;
  final RxInt timeRemaining = otpResendDelay.obs;
  final RxBool canResend = false.obs;

  /// Toggles between login and registration view
  void toggleView() => isLogin.value = !isLogin.value;

  /// Toggles password visibility
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;

  /// Toggles confirm password visibility
  void toggleConfirmPasswordVisibility() => isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  /// Handles file selection for doctor's credentials
  Future<void> pickFile(TextEditingController uploadFileController) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedFileExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        selectedFilePath.value = file.path ?? '';
        uploadFileController.text = '${file.name}.${file.extension}';
        
        CustomSnackBar.showCustomSnackBar(
          title: 'file_selected'.tr,
          message: '${'file_selected_message'.tr}: ${file.name}',
        );
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'file_error_message'.tr,
      );
      debugPrint('Error picking file: $e');
    }
  }

  /// Handles doctor registration
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String country,
    required String specialty,
    required File? documentFile,
  }) async {
    try {
      isLoading.value = true;

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'country': country,
        'specialty': specialty,
        'createdAt': FieldValue.serverTimestamp(),
      });

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Account created successfully'.tr,
      );
      Get.offNamed(Routes.DOCTOR_LOGIN);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles doctor sign in
  Future<void> signIn({required String email, required String password}) async {
    try {
      isLoading.value = true;

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Login successful'.tr,
      );
      Get.offAllNamed(Routes.DOCTOR_HOME);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Initiates password reset process
  Future<void> forgetPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      
      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Password reset email sent'.tr,
      );
      startTimer();
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Handles Firebase authentication errors
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String errorMessage = '';
    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found for this email.'.tr;
        break;
      case 'wrong-password':
        errorMessage = 'Incorrect password.'.tr;
        break;
      case 'email-already-in-use':
        errorMessage = 'Email is already registered.'.tr;
        break;
      case 'invalid-email':
        errorMessage = 'Invalid email address.'.tr;
        break;
      case 'weak-password':
        errorMessage = 'Password is too weak.'.tr;
        break;
      default:
        errorMessage = 'An error occurred: ${e.message}'.tr;
    }
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Error'.tr,
      message: errorMessage,
    );
  }

  /// Starts OTP timer countdown
  void startTimer() {
    timeRemaining.value = otpResendDelay;
    canResend.value = false;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        timeRemaining.value--;
      }
    });
  }

  /// Sets OTP digit at specified index
  void setDigit(int index, String value) {
    if (value.length <= 1 && index < otpLength) {
      otpDigits[index] = value;
    }
  }

  /// Handles OTP resend request
  Future<void> resendOTP(String email) async {
    try {
      isLoading.value = true;
      await forgetPassword(email);
      otpDigits.assignAll(List.generate(otpLength, (index) => ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies entered OTP
  Future<void> verifyOTP() async {
    try {
      isLoading.value = true;
      final otp = otpDigits.join();
      
      if (otp.length != otpLength) {
        throw 'Please enter complete OTP';
      }

      // Add actual OTP verification logic here
      await Future.delayed(const Duration(seconds: 2));
      Get.offAllNamed(Routes.DOCTOR_RESET_PASSWORD);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
