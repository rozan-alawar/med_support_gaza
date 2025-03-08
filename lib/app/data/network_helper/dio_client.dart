import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';

import '../../core/widgets/custom_snackbar_widget.dart';

class DioClient {
  Dio dio;
  DioClient(this.dio) {
    dio
      ..options.baseUrl = Links.baseLink
      ..options.connectTimeout =
          const Duration(seconds: DioConfig.connectTimeout)
      ..options.receiveTimeout =
          const Duration(seconds: DioConfig.receiveTimeout)
      ..options.sendTimeout = const Duration(seconds: DioConfig.sendTimeout)
      ..options.responseType = ResponseType.json
      ..options.followRedirects = true;
    dio.interceptors.add(ErrorInterceptor());
  }
}

class DioConfig {
  static const int connectTimeout = 60;
  static const int receiveTimeout = 60;
  static const int sendTimeout = 60;
}

class ErrorInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print(
        "┌------------------------------------------------------------------------------");
    print('''| [DIO] Request: ${options.method} ${options.uri}
| ${options.data.toString()}
''');
    print('Request Headers: ${options.headers}');
    print('Request Body: ${options.data}');

    handler.next(options);
  }

  @override
  void onResponse(response, ResponseInterceptorHandler handler) {
    if (response.data['message'] != null) {
      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: response.data['message'],
      );
    }
    print(
        "| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
    print(
        "└------------------------------------------------------------------------------");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    print(
        "└------------------------------------------------------------------------------");
    print('Dio Error Type: ${err.type}');
    print('Dio Error Message: ${err.message}');
    print('Dio Error Response: ${err.response}');
    print('Dio Error RequestOptions: ${err.requestOptions.uri}');

    if (err.response != null) {
      print('Response Status Code: ${err.response?.statusCode}');
      print('Response Data: ${err.response?.data}');
    }
    // Special handling for redirects
    if (err.response?.statusCode == 302) {
      print('Received redirect response: ${err.response?.headers['location']}');
      // You might want to follow the redirect manually or handle it differently
    }
    final error = DioExceptions.fromDioError(err);
    CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr, message: error.message);
  }
}

class DioExceptions implements Exception {
  late String message;
  DioExceptions.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.cancel:
        message = 'Request to API server was cancelled';
        break;
      case DioExceptionType.connectionTimeout:
        message = "Connection timeout with API server";
        break;
      case DioExceptionType.receiveTimeout:
        message = "Receive timeout in connection with API server";
        break;
      case DioExceptionType.badResponse:
        message = _handleError(
            dioError.response?.statusCode, dioError.response?.data);
        break;
      case DioExceptionType.sendTimeout:
        message = "Send timeout in connection with API server";
        break;
      case DioExceptionType.connectionError:
        message = " Socket Exceptions";
        break;
      case DioExceptionType.unknown:
        message = "Unexpected error occurred";
        break;

      default:
        message = "Something went wrong";
        break;
    }
  }

  String _handleError(int? statusCode, dynamic error) {
    const errorMessages = {
      400: 'Bad request',
      401: 'UnAuthorized',
      403: 'Forbidden',
      404: 'NotFound',
      500: 'Internal server error',
      502: 'Bad gateway',
    };
    // Check if the error response contains a message
    if (error != null && error is Map && error.containsKey('message')) {
      return error['message'].toString();
    }
    return errorMessages[statusCode] ?? 'Oops something went wrong';
  }

  @override
  String toString() => message;
}
