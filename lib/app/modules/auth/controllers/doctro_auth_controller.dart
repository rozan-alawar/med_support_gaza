import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../routes/app_pages.dart';

class DoctorAuthController extends GetxController {
  RxString selectedFilePath = ''.obs;
  RxBool isUploading = false.obs;
  final isLogin = true.obs;
  final isPasswordVisible = false.obs;
  final isPasswordVisible2 = false.obs;
  final isLoading = false.obs;

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
            message:'${'file_selected_message'.tr} :${result.files.single.name}');
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

  Future<void> uploadFile(
    TextEditingController uploadFileController,
  ) async {
    await pickFile(uploadFileController);

    //  try {
    //   Dio dio = Dio();

    //    إنشاء بيانات الطلب
    //   FormData formData = FormData.fromMap({
    //     "file": await MultipartFile.fromFile(
    //       selectedFilePath,
    //       filename: selectedFilePath.split('/').last, // اسم الملف
    //     ),
    //   });

    //    إرسال الملف إلى الخادم
    //   Response response = await dio.post(
    //     serverUrl,
    //     data: formData,
    //     options: Options(
    //       headers: {
    //         "Content-Type": "multipart/form-data",
    //       },
    //     ),
    //   );

    //   if (response.statusCode == 200) {
    //     print('File uploaded successfully');
    //   } else {
    //     print('File upload failed with status: ${response.statusCode}');
    //   }
    // } catch (e) {
    //   print('Error uploading file: $e');
    // }
  }

  //-------------------------------------- Sign Up -------------------------------------

  void signUp() {}

  //-------------------------------------- Sign IN -------------------------------------

  void signIn() {}

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
