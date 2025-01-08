import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';

class AppointmentService extends GetxService {
  final storage = Get.find<GetStorage>();
  final String appointmentsKey = 'appointments';

  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final List<dynamic> storedData = storage.read(appointmentsKey) ?? [];
      return storedData
          .map((json) => AppointmentModel.fromJson(json))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> saveAppointment(AppointmentModel appointment) async {
    try {
      final appointments = await getAppointments();
      appointments.add(appointment);
      await storage.write(appointmentsKey,
          appointments.map((app) => app.toJson()).toList());
    } catch (e) {
      throw Exception('Failed to save appointment');
    }
  }
}