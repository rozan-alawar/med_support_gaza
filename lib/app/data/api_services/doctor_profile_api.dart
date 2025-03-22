import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:dio/dio.dart' as di;
import 'package:get/instance_manager.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import '../network_helper/dio_client.dart';
import 'package:mime/mime.dart';

class DoctorProfileAPI {
  Future<di.Response<dynamic>> getDoctorProfile({
    required String token,
  }) async {
    final res = await Get.find<DioClient>().dio.get(Links.doctorProfile,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          followRedirects: true,
        ));

    return res;
  }

  Future<di.Response<dynamic>> updateDoctorProfile({
    String? email,
    String? fName,
    String? lName,
    String? gender,
    String? phoneNumber,
    String? major,
    String? country,
    required String token,
  }) async {
    print(''''first_name': $fName,
      'last_name': $lName,
      'email': $email,
      'country': $country,
      'phone_number': $phoneNumber,
      'gender': $gender,
      'major': $major,''');
      
    di.FormData formData = di.FormData.fromMap({
      'first_name': fName,
      'last_name': lName,
      'email': email,
      'country': country,
      'phone_number': phoneNumber,
      'gender': gender,
      'major': major,
    });


    final res = await Get.find<DioClient>().dio.post(
          Links.doctorUpdateProfile,
          data: formData,
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'multipart/form-data',
              'Accept': 'application/json',
            },
            followRedirects: true,
          ),
        );

    return res;
  }


  Future<di.Response<dynamic>> updateDoctorImageProfile({
  required String imagePath,
  required String token,
}) async {
  final file = File(imagePath);
  final fileType = lookupMimeType(imagePath);

  di.FormData formData = di.FormData.fromMap({
    'image': await di.MultipartFile.fromFile(
      file.path,
      filename: file.path.split('/').last,
      contentType: MediaType.parse(fileType!),
    ),
  });

  final res = await Get.find<DioClient>().dio.post(
        Links.doctorUpdateProfile,
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'multipart/form-data',
            'Accept': 'application/json',
          },
          followRedirects: true,
        ),
      );

  return res;
}
}
