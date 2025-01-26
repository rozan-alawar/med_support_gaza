import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/home/controllers/articles_controller.dart';
import 'package:med_support_gaza/app/modules/home/controllers/patient_doctors_controller.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<HealthTipsController>(
          () => HealthTipsController(),
    );
    Get.lazyPut<PatientDoctorsController>(
          () => PatientDoctorsController(),
    );
  }
}
