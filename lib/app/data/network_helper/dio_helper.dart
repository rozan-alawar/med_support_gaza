// ignore_for_file: constant_identifier_names

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as getx;
import 'package:med_support_gaza/app/data/api_paths.dart';
import 'package:med_support_gaza/app/data/network_helper/strings.dart';

import 'api_exception.dart';

class DioHelper {
  static late final Dio _dio;
  static late final Dio _benzolDio;

  static void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: Links.baseLink,
        receiveDataWhenStatusError: true,
      ),
    );
    _benzolDio = Dio(
      BaseOptions(
        baseUrl: Links.baseLink,
        receiveDataWhenStatusError: true,
      ),
    );
    _dio.interceptors.add(dioLoggerInterceptor);
    _benzolDio.interceptors.add(dioLoggerInterceptor);
  }

  static const int TIME_OUT_DURATION = 15000;

  static post(
      String url, {
        Map<String, dynamic>? headers,
        Map<String, dynamic>? queryParameters,
        required Function(Response response) onSuccess,
        Function(ApiException)? onError,
        Function(int total, int progress)? onSendProgress,
        Function(int total, int progress)? onReceiveProgress,
        Function? onLoading,
        dynamic data,
      }) async {
    try {
      // Indicate loading state
      onLoading?.call();

      // Perform HTTP request
      var response = await _dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        options: Options(
          headers: headers,
          receiveTimeout: const Duration(seconds: TIME_OUT_DURATION),
          sendTimeout: const Duration(seconds: TIME_OUT_DURATION),
        ),
      );

      // Call success function
      await onSuccess.call(response);
    } on DioException catch (error) {
      print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
      print('${error.message} rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr');
      log("DioException occurred: ${error.toString()}");

      String errorMessage = Strings.someThingWentWorng.tr; // Default message
      int statusCode = error.response?.statusCode ?? 0;

      if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        errorMessage = Strings.serverNotResponding.tr;
      } else if (error.type == DioExceptionType.badResponse && error.response != null) {
        var responseData = error.response!.data;

        if (responseData is Map<String, dynamic>) {
          // Extract main error message
          if (responseData.containsKey("message") && responseData["message"] is String) {
            errorMessage = responseData["message"];
          }

          // Extract validation errors (if present)
          if (responseData.containsKey("errors")) {
            var errors = responseData["errors"];
            if (errors is Map<String, dynamic>) {
              for (var key in errors.keys) {
                var errorList = errors[key];
                if (errorList is List && errorList.isNotEmpty) {
                  errorMessage = errorList.first.toString();
                  break;
                }
              }
            }
          }
        }

        statusCode = error.response?.statusCode ?? 400;
      } else if (error.type == DioExceptionType.unknown) {
        errorMessage = Strings.noInternetConnection.tr;
      }

      var exception = ApiException(
        message: (error.response!.data["message"]?.toString()) != "null"
            ? (error.response!.data["message"].toString())
            : "",
        url: Links.baseLink + url,
        statusCode: statusCode,
      );

      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      log("No internet connection");
      return onError?.call(ApiException(
        message: Strings.noInternetConnection.tr,
        url: Links.baseLink + url,
      )) ?? _handleError(Strings.noInternetConnection.tr);
    } on TimeoutException {
      log("API call timed out");
      return onError?.call(ApiException(
        message: Strings.serverNotResponding.tr,
        url: Links.baseLink + url,
      )) ?? _handleError(Strings.serverNotResponding.tr);
    } catch (error, stackTrace) {
      log("Unexpected error: $error\n$stackTrace");
      return onError?.call(ApiException(
        message: error.toString(),
        url: Links.baseLink + url,
      )) ?? handleApiError(ApiException(
        message: error.toString(),
        url: Links.baseLink + url,
      ));
    }
  }

  // GET request
  static get(String url,
      {Map<String, dynamic>? headers,
      Map<String, dynamic>? queryParameters,
      required Function(Response response) onSuccess,
      required Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      Function? onLoading,
      bool isBenzolLink = false}) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      late Response response;

      if (isBenzolLink == false) {
        response = await _dio
            .get(
              url,
              onReceiveProgress: onReceiveProgress,
              queryParameters: queryParameters,
              options: Options(
                headers: headers,
              ),
            )
            .timeout(const Duration(seconds: TIME_OUT_DURATION));
      } else {
        response = await _benzolDio
            .get(
              url,
              onReceiveProgress: onReceiveProgress,
              queryParameters: queryParameters,
              options: Options(
                headers: headers,
              ),
            )
            .timeout(const Duration(seconds: TIME_OUT_DURATION));
      }
      await onSuccess(response);
    } on DioException catch (error) {
      log("Dio Error");
      if (error.message!.toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: Strings.noInternetConnection,
              url: url,
            )) ??
            _handleError(Strings.noInternetConnection);
      }
      if (error.response == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }
      if (error.response?.statusCode == 500) {
        var exception = ApiException(
          message: Strings.serverError,
          url: url,
          statusCode: 500,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }
    } on SocketException {
      log("SocketException");

      onError?.call(ApiException(
            message: Strings.noInternetConnection,
            url: url,
          )) ??
          _handleError(Strings.noInternetConnection);
    } on TimeoutException {
      log("SocketException");

      onError?.call(ApiException(
            message: Strings.serverNotResponding,
            url: url,
          )) ??
          _handleError(Strings.serverNotResponding);
    }
    // catch (error) {
    //   onError?.call(ApiException(
    //         message: error.toString(),
    //         url: url,
    //       )) ??
    //       _handleError(error.toString());
    // }
  }

  // PUT request
  static put(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function(int total, int progress)?
        onSendProgress, // while sending (uploading) progress
    Function(int total, int progress)?
        onReceiveProgress, // while receiving data(response)
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.put(
        url,
        data: data,
        onReceiveProgress: onReceiveProgress,
        onSendProgress: onSendProgress,
        queryParameters: queryParameters,
        options: Options(
            headers: headers,
            receiveTimeout: const Duration(seconds: TIME_OUT_DURATION),
            sendTimeout: const Duration(seconds: TIME_OUT_DURATION)),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioException catch (error) {
      // dio error (api reach the server but not performed successfully
      // no internet connection
      if (error.message!.toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: Strings.noInternetConnection.tr,
              url: url,
            )) ??
            _handleError(Strings.noInternetConnection.tr);
      }

      // no response
      if (error.response == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      // check if the error is 500 (server problem)
      if (error.response?.statusCode == 500) {
        var exception = ApiException(
          message: Strings.serverError.tr,
          url: url,
          statusCode: 500,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      var exception = ApiException(
        message: error.message!,
        url: url,
        statusCode: error.response?.statusCode ?? 404,
      );
      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      // No internet connection
      onError?.call(ApiException(
            message: Strings.noInternetConnection.tr,
            url: url,
          )) ??
          _handleError(Strings.noInternetConnection.tr);
    } on TimeoutException {
      // Api call went out of time
      onError?.call(ApiException(
            message: Strings.serverNotResponding.tr,
            url: url,
          )) ??
          _handleError(Strings.serverNotResponding.tr);
    } catch (error) {
      log("asd");
      // unexpected error for example (parsing json error)
      onError?.call(ApiException(
            message: error.toString(),
            url: url,
          )) ??
          _handleError(error.toString());
    }
  }

  // DELETE request
  static delete(
    String url, {
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    required Function(Response response) onSuccess,
    Function(ApiException)? onError,
    Function? onLoading,
    dynamic data,
  }) async {
    try {
      // 1) indicate loading state
      onLoading?.call();
      // 2) try to perform http request
      var response = await _dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: Options(
            headers: headers,
            receiveTimeout: const Duration(seconds: TIME_OUT_DURATION),
            sendTimeout: const Duration(seconds: TIME_OUT_DURATION)),
      );
      // 3) return response (api done successfully)
      await onSuccess.call(response);
    } on DioException catch (error) {
      // dio error (api reach the server but not performed successfully
      // no internet connection
      if (error.message!.toLowerCase().contains('socket')) {
        onError?.call(ApiException(
              message: Strings.noInternetConnection.tr,
              url: url,
            )) ??
            _handleError(Strings.noInternetConnection.tr);
      }

      // no response
      if (error.response == null) {
        var exception = ApiException(
          url: url,
          message: error.message!,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      // check if the error is 500 (server problem)
      if (error.response?.statusCode == 500) {
        var exception = ApiException(
          message: Strings.serverError.tr,
          url: url,
          statusCode: 500,
        );
        return onError?.call(exception) ?? handleApiError(exception);
      }

      var exception = ApiException(
        message: error.message!,
        url: url,
        statusCode: error.response?.statusCode ?? 404,
      );
      return onError?.call(exception) ?? handleApiError(exception);
    } on SocketException {
      // No internet connection
      onError?.call(ApiException(
            message: Strings.noInternetConnection.tr,
            url: url,
          )) ??
          _handleError(Strings.noInternetConnection.tr);
    } on TimeoutException {
      // Api call went out of time
      onError?.call(ApiException(
            message: Strings.serverNotResponding.tr,
            url: url,
          )) ??
          _handleError(Strings.serverNotResponding.tr);
    } catch (error) {
      // unexpected error for example (parsing json error)
      onError?.call(ApiException(
            message: error.toString(),
            url: url,
          )) ??
          _handleError(error.toString());
    }
  }

  /// download file
  static download(
      {required String url, // file url
      required String savePath, // where to save file
      Function(ApiException)? onError,
      Function(int value, int progress)? onReceiveProgress,
      required Function onSuccess}) async {
    try {
      await _dio.download(
        url,
        savePath,
        onReceiveProgress: onReceiveProgress,
      );
      onSuccess();
    } catch (error) {
      var exception = ApiException(url: url, message: error.toString());
      onError?.call(exception) ?? _handleError(error.toString());
    }
  }

  static handleApiError(ApiException apiException) {
    if (getx.Get.isDialogOpen!) {
      getx.Get.back();
    }
    // String msg =
        // apiException.response?.data?['message'] ?? apiException.message;
    // log("msg1  $msg");
    // CustomSnackBar.showCustomErrorSnackBar(message: msg, title: 'Error');
  }

  static _handleError(String msg) {
    if (getx.Get.isDialogOpen!) {
      getx.Get.back();
    }
    log("msg2  $msg");

    // CustomSnackBar.showCustomErrorSnackBar(message: msg, title: 'error');
  }
}

final dioLoggerInterceptor =
    InterceptorsWrapper(onRequest: (RequestOptions options, handler) {
  String headers = "";
  options.headers.forEach((key, value) {
    headers += "| $key: $value";
  });

  log("┌------------------------------------------------------------------------------");
  log('''| [DIO] Request: ${options.method} ${options.uri}
| ${options.data.toString()}
| Headers:\n$headers''');
  log("├------------------------------------------------------------------------------");
  handler.next(options); //continue
}, onResponse: (Response response, handler) async {
  log("| [DIO] Response [code ${response.statusCode}]: ${response.data.toString()}");
  log("└------------------------------------------------------------------------------");
  handler.next(response);
  // return response; // continue
}, onError: (DioException error, handler) async {
  log("| [DIO] Error: ${error.error}: ${error.response.toString()}");
  log("└------------------------------------------------------------------------------");
  handler.next(error); //continue
});
