import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class AdminProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out: $e');
    }
  }
}
