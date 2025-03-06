import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import '../network_helper/api_exception.dart';
import '../network_helper/dio_client.dart';
import '../network_helper/dio_helper.dart';

class DoctorAuthApi {
  DoctorAuthApi();

  Future<Response<dynamic>> register({
    required String fName,
    required String lName,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String gender,
    required String phoneNumber,
    required String major,
    required String country,
    required String certificatePath,
  }) async {
    // Create FormData for file upload
    FormData formData = FormData.fromMap({
      'first_name': fName,
      'last_name': lName,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'gender': gender,
      'phone_number': phoneNumber,
      'major': major,
      'country': country,
      'certificate': await MultipartFile.fromFile(certificatePath,
          filename: certificatePath.split('/').last),
    }); // Adjust filename as needed

    // Make the POST request
    Response response = await Get.find<DioClient>().dio.post(
          Links.doctorRegister,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
          ),
        );
    return response;
  }

  Future<Response<dynamic>> login({
    required String email,
    required String password,
  }) async {
    Response response = await Get.find<DioClient>().dio.post(
      Links.doctorLogin,
      data: {
        'email': email,
        'password': password,
      },
    );
    return response;
  }

  Future<Response<dynamic>> forgetPassword({
    required String email,
  }) async {
    Response response = await Get.find<DioClient>().dio.post(
      Links.forgotPassword,
      data: {
        'email': email,
      },
    );
    return response;
  }

  // verify-otp function 
  Future<Response<dynamic>> verifyOTP({
    required int otp,
    required String email,
  }) async {
    Response response = await Get.find<DioClient>().dio.post(
      Links.verifyOTP,
      data: {
         'otp' : otp,
        'email': email,

      },
    );
    return response;
  }

  Future<Response<dynamic>> resetPassword({
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    Response response = await Get.find<DioClient>().dio.post(
      Links.resetPassword,
      data: {
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );
    return response;
  }

 Future<Response<dynamic>> logout({
    required String token,
  }) async{
  Response response = await Get.find<DioClient>().dio.post(
      Links.logout,
      data: {'token': token},
    );
    return response;
  }
}
