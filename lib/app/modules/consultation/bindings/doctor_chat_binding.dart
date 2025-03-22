import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/consultation/controllers/doctor_chat_controller.dart';

class DoctorChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorChatController>(
      () => DoctorChatController(userId: Get.arguments['userId'],
            consultationId: Get.arguments['consultationId'],),
    );
    
  }
}