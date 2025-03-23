import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/api_exception.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';

class ArticlesAPIService {

//------------------------ GET ARTICLES -----------------------------

  static void getArticles({

    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.get(
      Links.GET_ARTICLES,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }
//------------------------ ADD ARTICLE -----------------------------
  static void addArticle({
    required PlatformFile selectedImage,
    required String title,
    required String summary,
    required String content,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) async{
    final token = CacheHelper.getData(key: 'token_admin');
    FormData formData = FormData.fromMap({
    'title': title,
    'content':content,
    'summary':summary, // Empty for now
    'image': selectedImage != null
    ? await MultipartFile.fromFile(selectedImage!.path!)
        : null,
    });

    DioHelper.post(
      Links.ADD_ARTICLE,
    data: formData,
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }


//------------------------ UPDATE ARTICLE -----------------------------
  static void updateArticle({
    required String articleId,
    required String image,
    required String title,
    required String summary,
    required String content,
    required dynamic Function(Response<dynamic>) onSuccess,
    dynamic Function(ApiException)? onError,
    Function? onLoading,
  }) {
    final token = CacheHelper.getData(key: 'token_admin');

    DioHelper.put(
      '${Links.UPDATE_ARTICLE}$articleId',
      data: {
        'image': image,
        'title': title,
        'summary': summary,
        'content': content,
      },
      headers: {'Authorization': 'Bearer $token'},
      onSuccess: onSuccess,
      onError: onError,
      onLoading: onLoading,
    );
  }


}
