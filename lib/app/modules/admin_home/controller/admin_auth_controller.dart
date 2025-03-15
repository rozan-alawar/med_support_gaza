import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/data/api_services/admin_auth_api.dart';
import 'package:med_support_gaza/app/data/models/admin_login_response.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';

import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../data/firebase_services/firebase_handler.dart';
import '../../../data/firebase_services/firebase_services.dart';
import '../../../routes/app_pages.dart';

class AdminController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();

  final isLogin = true.obs;
  final isPasswordVisible = true.obs;
  final isLoading = false.obs;
   Rx<AdminModel?> admin = Rx<AdminModel?>(null);
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

  }


  //------------------------ SIGN IN -----------------------------

  void signIn({
    required String email,
    required String password,
  }) {
    AdminAuthAPIService.signIn(
      email: email,
      password: password,
      onSuccess: (response) {
        isLoading.value = false;
        AdminLoginResponseModel loginResponse =
        AdminLoginResponseModel.fromJson(response.data);
        _showSuccessMessage(loginResponse.message);

        CacheHelper.saveData(key: 'isLoggedIn', value: true);
        CacheHelper.saveData(key: 'userType', value: 'admin');

        admin.value = loginResponse.admin;
        CacheHelper.saveData(key: 'admin', value: json.encode(admin));

        CacheHelper.saveData(key: 'token_admin', value: loginResponse.token);
        Get.offAllNamed(Routes.ADMIN_HOME);
      },
      onError: (e) {
        isLoading.value = false;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //------------------------ SIGN OUT -----------------------------

  void signOut() {
    String token = CacheHelper.getData(key: 'token_admin');

    if (token == null) {
      _handleError('Error'.tr, 'No active session found');
      Get.offAllNamed(Routes.User_Role_Selection);
      return;
    }

    AdminAuthAPIService.logout(
      token: token,
      onSuccess: (response) {
        isLoading.value = false;

        CacheHelper.removeData(key: 'admin');
        CacheHelper.removeData(key: 'token_admin');
        CacheHelper.removeData(key: 'isLoggedIn');
        CacheHelper.removeData(key: 'userType');

        Get.offAllNamed(Routes.User_Role_Selection);
      },
      onError: (e) {
        isLoading.value = false;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }
  void _handleError(String title, String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: title,
      message: message,
    );
  }

  void _showSuccessMessage(String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      message: message,
      color: Colors.green,
      title: 'Success'.tr,
    );
  }
}
