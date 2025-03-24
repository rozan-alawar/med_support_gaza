import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class PatientAppointmentAPIService {

//------------------------ GET DOCTORS SPECIALIZATIONS -----------------------------

  static void getDoctorsSpecializations({

    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_patient');

    DioHelper.get(
      Links.GET_DOCTORS_SPECIALIZATIONS,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ GET DOCTORS BY SPECIALIZATION -----------------------------

  static void getDoctorsBySpecialization({
    required String specialization,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_patient');
    DioHelper.get(
      '${Links.GET_DOCTORS_BY_SPECIALIZATION}/$specialization',
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }



}
