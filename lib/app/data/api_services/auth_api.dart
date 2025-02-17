import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

import '../network_helper/api_exception.dart';

class AuthAPIService {
//------------------------ SIGN IN -----------------------------

  static void signIn({
    required String phoneCode,
    required String phoneNumber,
    // required RxBool loading,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.login,
      data: {
        'phone_code': phoneCode,
        'phone_number': phoneNumber,
      },
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

//------------------------ SIGN UP -----------------------------

  static void signUp({
    required String firstName,
    required String lastName,
    required String email,
    required String dob,
    required String gender,
    required String phoneNumber,
    required String phoneCode,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.login,
      data: {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'dob': dob,
        'gender': gender,
        'phone_number': phoneNumber,
        'phone_code': phoneCode,
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
      Links.verify,
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
      Links.logout,
      data: {'token': token},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
}
