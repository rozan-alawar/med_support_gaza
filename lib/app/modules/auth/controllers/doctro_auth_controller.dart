import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';

class DoctorAuthController extends GetxController {
  RxString selectedFilePath = ''.obs;
  RxBool isUploading = false.obs;
  final isLogin = true.obs;
  final isPasswordVisible = false.obs;
  final isPasswordVisible2 = false.obs;

  // void toggleView() {
  //   isLogin.value = !isLogin.value;
  // }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

   void togglePasswordVisibility2() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> pickFile(TextEditingController  uploadFileController) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        selectedFilePath.value = result.files.single.path ?? '';
        Get.snackbar('File Selected', 'File: ${result.files.single.name}');
        uploadFileController.text = '${result.files.single.name}.${result.files.single.extension}';
      } else {
        Get.snackbar('No File Selected', 'Please choose a file.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error picking file: $e');
      print('Error picking file: $e');
    }
  }

  Future<void> uploadFile(TextEditingController  uploadFileController , ) async {
   await  pickFile(uploadFileController);

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

  void signUp() {

  }
}
