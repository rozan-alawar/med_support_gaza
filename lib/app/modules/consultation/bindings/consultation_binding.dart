import 'package:get/get.dart';

import '../controllers/consultation_controller.dart';

class ConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultationController>(
      () => ConsultationController(),
    );
  }
}
