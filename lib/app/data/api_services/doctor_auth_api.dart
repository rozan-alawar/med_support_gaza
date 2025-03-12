import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart';
import 'package:get/instance_manager.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import '../network_helper/dio_client.dart';
import 'package:mime/mime.dart';

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
    final file = File(certificatePath);
    final fileType = lookupMimeType(certificatePath);
    FormData formData = FormData.fromMap({
      'first_name': fName,
      'last_name': lName,
      'email': email,
      'password': password,
      'country': country,
      'phone_number': phoneNumber,
      'gender': gender,
      'major': major,
      'certificate': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
        contentType: MediaType.parse(fileType!),
      ),
      'password_confirmation': passwordConfirmation,
    }); // Adjust filename as needed

    // Make the POST request
    Response response = await Get.find<DioClient>().dio.post(
          Links.doctorRegister,
          data: formData,
          options: Options(
            headers: {
              'Content-Type': 'multipart/form-data',
              'Accept': 'application/json',
            },
            followRedirects: true,
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
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
      ),
      data: {
        'email': email,
      },
    );
    return response;
  }

  // verify-otp function
  Future<Response<dynamic>> verifyOTP({
    required String otp,
    required String email,
  }) async {
    Response response = await Get.find<DioClient>().dio.post(
      Links.verifyOTP,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
      ),
      data: {
        'otp': int.parse(otp),
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
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
      ),
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
  }) async {
    Response response = await Get.find<DioClient>().dio.post(
      Links.doctorLogout,
      options: Options(
        headers: {
           'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        followRedirects: true,
      ),
    );
    return response;
  }
}
