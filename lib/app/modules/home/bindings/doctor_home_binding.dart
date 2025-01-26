import 'package:get/get.dart';
import '../../appointment_booking/controllers/doctor_appointment_management_controller.dart';
import '../../consultation/controllers/doctor_consultation_controller.dart';
import '../controllers/doctor_home_controller.dart';


class DoctorHomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorHomeController>(
      () => DoctorHomeController(),
    );
     Get.lazyPut<DoctorAppointmentManagementController>(
      () => DoctorAppointmentManagementController(),
    );
     Get.lazyPut< DoctorConsultationController>(
      () =>  DoctorConsultationController(),
    );
  }
}
