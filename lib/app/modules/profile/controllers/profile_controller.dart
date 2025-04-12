import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/api_services/patient_auth_api.dart';
import 'package:med_support_gaza/app/data/api_services/patient_profile_api.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/auth_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final RxBool isLoading = false.obs;
  Rx<PatientModel?> currentUser =
      Rx<PatientModel?>(AuthController().currentUser);

  // Edit Profile Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final RxString selectedGender = 'Female'.obs;
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

  void updateProfile() async {
    isLoading.value = true;

    PatientProfileAPIService.updatePatientProfile(
      firstName: firstNameController.text.trim(),
      lastName: lastNameController.text.trim(),
      phone_number: phoneController.text.trim(),
      age: int.parse(ageController.text.trim()),
      gender: selectedGender.value,
      address: selectedCountry.value,
      onSuccess: (response) async {
        isLoading.value = false;
        final patient = response.data['patient'];
        currentUser.value = PatientModel.fromJson(patient);
        await getProfile();

        CacheHelper.saveData(
            key: 'user', value: json.encode(currentUser.value!));

        CustomSnackBar.showCustomSnackBar(
          title: 'Success'.tr,
          message: 'Profile updated successfully'.tr,
        );
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //------------------------ SIGN OUT -----------------------------

  void signOut() {
    String token = CacheHelper.getData(key: 'token_patient');

    if (token == null) {
      _handleError('Error'.tr, 'No active session found');
      Get.offAllNamed(Routes.User_Role_Selection);
      return;
    }

    // PatientAuthAPIService.logout(
    //   token: token,
    //   onSuccess: (response) {
    //     isLoading.value = false;

        CacheHelper.removeData(key: 'user');
        CacheHelper.removeData(key: 'token_patient');

        CacheHelper.removeData(key: 'isLoggedIn');
        CacheHelper.removeData(key: 'userType');

        Get.offAllNamed(Routes.User_Role_Selection);
    //   },
    //   onError: (e) {
    //     isLoading.value = false;
    //     _handleError('Error'.tr, e.message);
    //   },
    //   onLoading: () {
    //     isLoading.value = true;
    //   },
    // );
  }

  Future<void> getProfile() async {
    isLoading.value = true;

    PatientProfileAPIService.getPatientProfile(
      onSuccess: (response) {
        isLoading.value = false;
        final patient = response.data['patient'];
        currentUser.value = PatientModel.fromJson(patient);
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
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

  void _handleError(String title, String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: title,
      message: message,
    );
  }
}
