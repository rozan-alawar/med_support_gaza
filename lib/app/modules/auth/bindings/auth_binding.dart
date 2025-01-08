import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';

import '../controllers/auth_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(
      () => AuthController(),
    );
    Get.lazyPut<FirebaseService>(
          () => FirebaseService(),
    );
  }
}
