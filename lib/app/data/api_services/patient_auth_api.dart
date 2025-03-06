import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class PatientAuthAPIService {
//------------------------ SIGN IN -----------------------------

  static void signIn({
    required String email,
    required String password,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.PATIENT_LOGIN,
      data: {'email': email, 'password': password},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

//------------------------ SIGN UP -----------------------------

  static void signUp({
    required String username,
    required String email,
    required String password,
    required String passwordConfirmation,
    required String firstName,
    required String lastName,
    required String age,
    required String gender,
    required String phoneNumber,
    required String address,
    required dynamic Function(Response<dynamic>) onSuccess,
    Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.PATIENT_REGISTER,
      data: {
        'username': username,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'first_name': firstName,
        'last_name': lastName,
        'age': age,
        'gender': gender,
        'phone_number': phoneNumber,
        'address': address,
      },
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ VERIFY PHONE NUMBER -----------------------------

  static void verifyNumber({
    required String phoneCode,
    required String phoneNumber,
    required String codeNumber,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.PATIENT_LOGIN,
      data: {
        'phone_code': phoneCode,
        'phone_number': phoneNumber,
        'code_number': codeNumber,
      },
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ LOGOUT -----------------------------

  static void logout({
    required String token,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.PATIENT_LOGOUT,
      data: {'token': token},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
}
