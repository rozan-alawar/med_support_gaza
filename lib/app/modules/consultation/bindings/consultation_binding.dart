import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/consultation/controllers/chat_controller.dart';

import '../controllers/consultation_controller.dart';

class ConsultationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsultationsController>(
      () => ConsultationsController(userId: Get.arguments['userId']),
    );
    Get.lazyPut<ChatController>(
          () => ChatController(
            userId: Get.arguments['userId'],
            consultationId: Get.arguments['consultationId'],
          ),
    );
  }
}
