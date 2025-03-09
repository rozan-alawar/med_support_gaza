import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class PatientProfileAPIService {
//------------------------ GET PATIENT PROFILE DATA  -----------------------------

  static void getPatientProfile({
    required String email,
    required String password,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.get(
      Links.PATIENT_PROFILE,
      headers: {"token": ""},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
  //------------------------ UPDATE PATIENT PROFILE DATA  -----------------------------

  static void updatePatientProfile({
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
}
