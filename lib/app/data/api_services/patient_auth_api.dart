import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
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

  //------------------------ FORGET PASSWORD -----------------------------

  static void forgetPassword({
    required String email,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.FORGET_PASSWORD,
      data: {
        'email': email,
      },
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ VERIFY OTP -----------------------------
  static void verifyOtp({
    required String email,
    required String otp,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.VERIFY_OTP,
      data: {
        'email': email,
        'otp': otp,
      },
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ RESET PASSWORD -----------------------------
  static void resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.RESET_PASSWORD,
      data: {
        'email': email,
        'new_password': newPassword,
        'confirm_password': confirmPassword,
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
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
}
