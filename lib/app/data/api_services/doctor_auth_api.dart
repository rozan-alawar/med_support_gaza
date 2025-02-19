import 'package:dio/dio.dart';

import '../network_helper/api_exception.dart';
import '../network_helper/dio_helper.dart';

class DoctorAuthApi {
  DoctorAuthApi();

  Future<Response> register(
      {required String path,
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
      required dynamic Function(Response<dynamic>) onSuccess}) async {
    try {
      if (password != passwordConfirmation) {
        throw Exception('Password and password confirmation do not match');
      }
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
      final response = await DioHelper.post(path,
          data: formData,
          contentType: 'multipart/form-data',
          onSuccess: onSuccess
          // (response) {
          //   // Handle successful response
          //   print('Registration successful: ${response.data}');
          // },
          );
      return response;
    } on DioException catch (e) {
      // Handle Dio errors (e.g., network issues, server errors)
      print('DioError: ${e.message}');
      throw Exception('Failed to register: ${e.message}');
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      throw Exception('Failed to register: $e');
    }
  }

  Future<Response> login(
      {required String path,
      required String email,
      required String password,
      required dynamic Function(Response<dynamic>) onSuccess}) async {
    try {
      // Validate input data
      if (email.isEmpty || password.isEmpty) {
        throw Exception('All fields are required');
      }

      final response = await DioHelper.post(path, onSuccess: onSuccess, data: {
        'email': email,
        'password': password,
      });

      return response;
    } catch (e) {
      // Handle other errors
      print('Error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  Future<Response> forgetPassword(
      {required String path,
      required String email,
      required dynamic Function(Response<dynamic>) onSuccess}) async {
    final response = await DioHelper.post(path, onSuccess: onSuccess, data: {
      'email': email,
    });

    return response;
  }

  Future<Response> resetPassword(
      {required String path,
      required String email,
      required int code,
      required String password,
      required String passwordConfirmation,
      required dynamic Function(Response<dynamic>) onSuccess}) async {
    final response = await DioHelper.post(path, onSuccess: onSuccess, data: {
      'email': email,
      'code': code,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });

    return response;
  }

  Future<Response> logout(
      {required String path,
      required String token,
      required dynamic Function(Response<dynamic>) onSuccess,
      dynamic Function(ApiException)? onError}) async {
    final response = await DioHelper.post(
      path,
      data: {'token': token},
      onError: onError,
      onSuccess: onSuccess,
    );
    return response;
  }
}
