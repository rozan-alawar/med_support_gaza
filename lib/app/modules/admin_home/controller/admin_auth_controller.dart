import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../data/firebase_services/firebase_handler.dart';
import '../../../data/firebase_services/firebase_services.dart';
import '../../../data/models/patient_model.dart';
import '../../../routes/app_pages.dart';

class AdminController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final isLogin = true.obs;
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<PatientModel?> patientData = Rx<PatientModel?>(null);

  void toggleView() {
    isLogin.value = !isLogin.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  @override
  void onInit() {
    super.onInit();
    currentUser.bindStream(_firebaseService.authStateChanges);
    ever(currentUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      // Fetch user data from Firestore
      try {
        patientData.value = await _firebaseService.getPatientData(user.uid);
      } catch (e) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.toString(),
        );
      }
    } else {
      patientData.value = null;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      await _firebaseService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // After successful login, check if the user is an admin
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        bool isAdmin = await _checkIfUserIsAdmin(user.uid);
        if (isAdmin) {
          Get.offAllNamed(Routes.ADMIN_HOME);
        } else {
          CustomSnackBar.showCustomErrorSnackBar(
            title: 'Error'.tr,
            message: 'You are not an admin.'.tr,
          );
        }
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: FirebaseErrorHandler.getErrorMessage(e.toString()),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> _checkIfUserIsAdmin(String uid) async {
    try {
      QuerySnapshot adminDocs = await FirebaseFirestore.instance
          .collection('admin')
          .where('email', isEqualTo: FirebaseAuth.instance.currentUser?.email)
          .get();

      if (adminDocs.docs.isNotEmpty) {
        DocumentSnapshot adminDoc = adminDocs.docs.first;
        String role = adminDoc['role'] ?? '';
        return role == 'admin';
      }

      return false;
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to check user role: ${e.toString()}',
      );
      return false;
    }
  }
}
