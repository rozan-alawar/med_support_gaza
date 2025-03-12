import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as di;
import 'package:get/instance_manager.dart';
import 'package:med_support_gaza/app/data/api_paths.dart';
import '../network_helper/dio_client.dart';

class DoctorAppointmentAPI {
  Future<di.Response<dynamic>> getDoctorAppointments({
    required String token,
    String? status,
  }) async {
    // if doctor available he can make this request
    final res = await Get.find<DioClient>()
        .dio
        .get('${Links.doctorAppointments}?status=${status ?? ''}',
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

  Future<di.Response<dynamic>> addDoctorAppointment({
    required String token,
    required String date,
    required String startTime,
    required String endTime,
  }) async {
    // if doctor available he can make this request
    final res = await Get.find<DioClient>().dio.post(Links.doctorAddSchedule,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
            'Accept': 'application/json'
          },
          followRedirects: true,
        ),
        data: {
          "date": date,
          "start_time": startTime,
          "end_time": endTime,
          "period": "half hour"
        });

    return res;
  }
}
