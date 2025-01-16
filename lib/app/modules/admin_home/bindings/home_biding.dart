import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_auth_controller.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_content_controller.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_doctors_controller.dart';

import '../../../data/firebase_services/firebase_services.dart';
import '../controller/admin_home_controller.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminController>(
      () => AdminController(),
    );
    Get.lazyPut<FirebaseService>(
      () => FirebaseService(),
    );
    Get.lazyPut<AdminHomeController>(
      () => AdminHomeController(),
    );
    Get.lazyPut<AdminDoctorsController>(
      () => AdminDoctorsController(),
    );
    Get.lazyPut<ContentController>(
          () => ContentController(),
    );
  }
}
