import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/auth_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;
   Rx<PatientModel?> currentUser =    Rx<PatientModel?>(AuthController().currentUser?.patient) ;



  // Edit Profile Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final RxString selectedGender = ''.obs;
  final RxString selectedCountry = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.onClose();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      dynamic user = await CacheHelper.getData(key: 'user');
      currentUser.value = PatientModel.fromJson(json.decode(user));

          _initializeControllers();


    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to load user data'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _initializeControllers() {
    PatientModel? user = currentUser.value;
    if (user != null) {
      firstNameController.text = user.firstName;
      lastNameController.text = user.lastName;
      phoneController.text = user.phoneNumber;
      ageController.text = user.age.toString();
      selectedGender.value = user.gender;
      selectedCountry.value = user.address.toString();
    }
  }

  Future<void> updateProfile() async {
    try {
      if (!_validateInputs()) return;

      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      final updatedData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phoneNo': phoneController.text.trim(),
        'age': ageController.text.trim(),
        'gender': selectedGender.value,
        'country': selectedCountry.value,
      };

      await _firestore.collection('patients').doc(user.uid).update(updatedData);

      await loadUserData();

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Profile updated successfully'.tr,
      );

      Get.back();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to update profile'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (firstNameController.text.trim().isEmpty ||
        lastNameController.text.trim().isEmpty ||
        phoneController.text.trim().isEmpty ||
        ageController.text.trim().isEmpty ||
        selectedGender.value.isEmpty ||
        selectedCountry.value.isEmpty) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Please fill all fields'.tr,
      );
      return false;
    }
    return true;
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(Routes.AUTH);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to sign out'.tr,
      );
    }
  }

  void onLanguageTap() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Icon(Icons.language, color: AppColors.primary),
                12.width,
                CustomText(
                  'select_language'.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            24.height,
            _buildLanguageOption('ar', 'العربية'),
            12.height,
            _buildLanguageOption('en', 'English'),
            24.height,
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget _buildLanguageOption(String code, String name) {
    final isSelected = Get.locale?.languageCode == code;
    return InkWell(
      onTap: () {
        Get.updateLocale(Locale(code));
        Get.back();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Row(
          children: [
            CustomText(
              name,
              fontSize: 16.sp,
              color: isSelected ? AppColors.primary : Colors.black,
            ),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  void onLogoutTap() {
    Get.dialog(
      AlertDialog(
        title: Text('logout_confirmation'.tr),
        content: Text('logout_message'.tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('cancel'.tr),
          ),
          TextButton(
            onPressed: signOut,
            child: Text(
              'confirm'.tr,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
