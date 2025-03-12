import 'package:dio/dio.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class AdminAuthAPIService {
//------------------------ SIGN IN -----------------------------

  static void signIn({
    required String email,
    required String password,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    DioHelper.post(
      Links.ADMIN_LOGIN,
      data: {'email': email, 'password': password},
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
    final token = CacheHelper.getData(key: 'token');

    DioHelper.post(
      Links.ADMIN_LOGOUT,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
}
