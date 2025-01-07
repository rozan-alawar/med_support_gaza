import 'package:get/get.dart';
import '../controllers/doctor_appointment_management_controller.dart';

class DoctorAppointmentManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAppointmentManagementController>(
      () => DoctorAppointmentManagementController(),
    );
  }
}