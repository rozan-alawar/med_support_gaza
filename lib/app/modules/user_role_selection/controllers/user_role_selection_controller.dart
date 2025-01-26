import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class UserRoleSelectionSeController extends GetxController {
  void navigateToDoctor() {
    Get.toNamed(Routes.DOCTRO_ONBOARDING);
  }

  void navigateToPatient() {
    Get.toNamed(Routes.PATIENT_ONBOARDING);
  }
}
