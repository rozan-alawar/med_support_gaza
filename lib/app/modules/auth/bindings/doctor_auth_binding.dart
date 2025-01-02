import 'package:get/get.dart';

import '../controllers/doctro_auth_controller.dart';

class DoctorAuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorAuthController>(
      () => DoctorAuthController(),
    );
  }
}
