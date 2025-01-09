import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/doctor_profile_controller.dart';

import '../controllers/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
      () => ProfileController(),

    );
    Get.lazyPut(()=>DoctorProfileController());
  }
}
