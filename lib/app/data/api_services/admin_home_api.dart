import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class AdminHomeAPIService {
  //------------------------ GET PATIENTS -----------------------------

  static void getPatients({
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.get(
      Links.GET_PATIENTS,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ GET DOCTORS -----------------------------

  static void getDoctors({
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.get(
      Links.GET_DOCTORS_List,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ DELETE PATIENT -----------------------------

  static void deletePatient({
    required String patientId,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.delete(
      "${Links.DELETE_PATIENT}$patientId",
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ DELETE DOCTOR -----------------------------

  static void deleteDoctor({
    required String doctorId,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.delete(
      "${Links.DELETE_DOCTOR}$doctorId",
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ GET PENDING DOCTORS -----------------------------

  static void getPendingDoctors({
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.get(
      "${Links.GET_PENDING_DOCTORS}?status=pending",
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ APPROVE DOCTOR -----------------------------
  static void approveDoctor({
    required String doctorId,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.put(
      '${Links.APPROVE_DOCTOR}/$doctorId',
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ DECLINE DOCTOR -----------------------------
  static void declineDoctor({
    required String doctorId,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.put(
      '${Links.DECLINE_DOCTOR}/$doctorId',
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
}
