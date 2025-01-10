import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../routes/app_pages.dart';

class DoctorAuthController extends GetxController {
  RxString selectedFilePath = ''.obs;
  RxBool isUploading = false.obs;
  final isLogin = true.obs;
  final isPasswordVisible = false.obs;
  final isPasswordVisible2 = false.obs;
  final isLoading = false.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final RxList<String> otpDigits = List.generate(4, (index) => '').obs;
  final RxInt timeRemaining = 15.obs;
  final RxBool canResend = false.obs;

  void toggleView() {
    isLogin.value = !isLogin.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void togglePasswordVisibility2() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  //-------------------------------------- Upload file -------------------------------------

  Future<void> pickFile(TextEditingController uploadFileController) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        selectedFilePath.value = result.files.single.path ?? '';
        // Get.snackbar('File Selected', 'File: ${result.files.single.name}');
        CustomSnackBar.showCustomSnackBar(
            title: 'file_selected'.tr,
            message:
                '${'file_selected_message'.tr} :${result.files.single.name}');
        uploadFileController.text =
            '${result.files.single.name}.${result.files.single.extension}';
      } else {
        CustomSnackBar.showCustomErrorSnackBar(
            title: 'file_not_selected'.tr,
            message: 'file_not_selected_message'.tr);
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'file_error_message'.tr,
      );
      print('Error picking file: $e');
    }
  }

  // Future<void> uploadFile(
  //   TextEditingController uploadFileController,
  // ) async {
  //   await pickFile(uploadFileController);

  //   //  try {
  //   //   Dio dio = Dio();

  //   //    إنشاء بيانات الطلب
  //   //   FormData formData = FormData.fromMap({
  //   //     "file": await MultipartFile.fromFile(
  //   //       selectedFilePath,
  //   //       filename: selectedFilePath.split('/').last, // اسم الملف
  //   //     ),
  //   //   });

  //   //    إرسال الملف إلى الخادم
  //   //   Response response = await dio.post(
  //   //     serverUrl,
  //   //     data: formData,
  //   //     options: Options(
  //   //       headers: {
  //   //         "Content-Type": "multipart/form-data",
  //   //       },
  //   //     ),
  //   //   );

  //   //   if (response.statusCode == 200) {
  //   //     print('File uploaded successfully');
  //   //   } else {
  //   //     print('File upload failed with status: ${response.statusCode}');
  //   //   }
  //   // } catch (e) {
  //   //   print('Error uploading file: $e');
  //   // }
  // }

  //-------------------------------------- Sign Up -------------------------------------

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

      // تسجيل مستخدم جديد
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? documentUrl;

      // رفع الوثيقة إلى Firebase Storage إذا تم تحديدها
      if (documentFile != null) {
        String filePath =
            'medical_certificates/${userCredential.user!.uid}.pdf';
        UploadTask uploadTask = _storage.ref(filePath).putFile(documentFile);
        TaskSnapshot snapshot = await uploadTask;
        documentUrl = await snapshot.ref.getDownloadURL();
      }

      // حفظ بيانات المستخدم في Firestore
      final doctorDoc = await _firestore
          .collection('doctors')
          .doc(userCredential.user!.uid)
          .set({
        'id': userCredential.user!.uid,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'country': country,
        'specialty': specialty,
        'documentUrl': documentUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _firestore
          .collection('doctors')
          .doc(userCredential.user!.uid)
          .collection('availableAppointments')
          .add({
        'date': '2025-01-10',
        'time': '10:00 AM',
        'createdAt': FieldValue.serverTimestamp(),
      });

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Account created successfully'.tr,
      );
      // الانتقال إلى الشاشة الرئيسية
      Get.offNamed(Routes.DOCTOR_LOGIN); // عدل اسم المسار حسب الحاجة
    } catch (e) {
      isLoading.value = false;

      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  //-------------------------------------- Sign IN -------------------------------------

  void signIn({required String email, required String password}) async {
    try {
      // Start loading indicator
      isLoading.value = true;

      // Attempt to sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to the main screen or dashboard after successful login
      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Login successful'.tr,
      );
      Get.offAllNamed(Routes.DOCTOR_HOME); // Adjust the route as per your app
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific exceptions
      String errorMessage = '';
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for this email.'.tr;
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password.'.tr;
          break;
        default:
          errorMessage = 'An error occurred: ${e.message}'.tr;
      }
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: errorMessage,
      );
    } catch (e) {
      // Handle other errors
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      // Stop loading indicator
      isLoading.value = false;
    }
  }

  //-------------------------------------- Forget Password -------------------------------------

  void forgetPassword() {}

  //-------------------------------------- Reset Password -------------------------------------

  void resetPassword() {}

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
          title: 'Error'.tr,
          message: 'PleaseEnterCompleteOTP'.tr,
        );
        return;
      }

      Timer(
        const Duration(seconds: 3),
        () => Get.offAllNamed(Routes.DOCTOR_RESET_PASSWORD),
      );
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Verification failed',
      );
    }
  }
}
