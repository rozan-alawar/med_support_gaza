import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class PatientProfileAPIService {

//------------------------ GET PATIENT PROFILE DATA  -----------------------------
  static void getPatientProfile({
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_patient');

    DioHelper.get(
      Links.PATIENT_PROFILE,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
  //------------------------ UPDATE PATIENT PROFILE DATA  -----------------------------s
  static void updatePatientProfile({
    required String firstName,
    required String lastName,
    required String phone_number,
    required String address,
    required int age,
    required String gender,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_patient');

    DioHelper.put(
      Links.UPDATE_PROFILE,
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "phone_number": phone_number,
        "address": address,
        "age": age,
        "gender": gender
      },
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
}
