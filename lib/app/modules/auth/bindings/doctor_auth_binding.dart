import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/doctro_auth_controller.dart';


class DoctorAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAuthController>(
      () => DoctorAuthController(),
    );
  }
}
