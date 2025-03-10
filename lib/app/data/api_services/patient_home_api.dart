import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';

class HomeAPIService {
  //------------------------ GET DOCTORS -----------------------------
  static void getDoctors({
    required dynamic Function(Response<dynamic>) onSuccess,
    Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token');

    DioHelper.get(
      headers: {'Authorization': 'Bearer $token'},
      Links.GET_DOCTORS,
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }

  //------------------------ SEARCH DOCTORS -----------------------------
  static void searchDoctors({
    required String major,
    required Function(List<DoctorModel>) onSuccess,
    Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.get(
      '${Links.SEARCH_DOCTOR}?major=$major',
      onSuccess: (Response<dynamic> response) {
        final List<DoctorModel> doctors = (response.data as List)
            .map((json) => DoctorModel.fromJson(json))
            .toList();
        onSuccess(doctors);
      },
      onError: onError,
      onLoading: onLoading,
    );
  }
}
