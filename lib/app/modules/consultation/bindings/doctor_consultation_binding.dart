import 'package:get/get.dart';
import '../controllers/doctor_consultation_controller.dart';

class DoctroConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorConsultationController>(
      () => DoctorConsultationController(),
    );
    
  }
}
