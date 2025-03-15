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
        });

    return res;
  }

  Future<di.Response<dynamic>> delelteDoctorAppointment({
    required String token,
    required int id,
  }) async {
    final res = await Get.find<DioClient>()
        .dio
        .delete('${Links.doctorDeleteAppointment}/$id',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
                'Accept': 'application/json'
              },
              followRedirects: true,
            ));

    return res;
  }

  Future<di.Response<dynamic>> getDoctorPendingAppointments({
    required String token,
  }) async {
    final res =
        await Get.find<DioClient>().dio.get(Links.doctorPendingAppointments,
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

  Future<di.Response<dynamic>> rejectAppointment({
    required String token,
    required int id,
  }) async {
    final res = await Get.find<DioClient>()
        .dio
        .put('${Links.doctorRejectAppointment}/$id',
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

  Future<di.Response<dynamic>> acceptAppointment({
    required String token,
    required int id,
  }) async {
    final res = await Get.find<DioClient>()
        .dio
        .put('${Links.doctorAcceptAppointment}/$id',
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
}
