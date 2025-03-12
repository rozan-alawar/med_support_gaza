import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/api_services/doctor_profile_api.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/doctro_auth_controller.dart';
import '../../../core/services/cache_helper.dart';
import '../../../data/models/doctor.dart';
import '../../../routes/app_pages.dart';

class DoctorProfileController extends GetxController {
  final DoctorProfileAPI _doctorProfileApi = Get.find<DoctorProfileAPI>();
  final isLoading = false.obs;
  final Rx<DoctorModel?> doctorData = Rx<DoctorModel?>(null);

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController aboutController;

  // Observable values
  final selectedGender = ''.obs;
  final selectedCountry = ''.obs;
  final selectedSpeciality = ''.obs;
  final selectedLanguages = <String>{}.obs;
  final selectedImagePath = ''.obs;
  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initializeControllers();
    fetchDoctorData();
  }

  void initializeControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  void populateFields() {
    if (doctorData.value?.doctor != null) {
      final doctor = doctorData.value?.doctor;
      firstNameController.text = doctor?.firstName ?? "";
      lastNameController.text = doctor?.lastName ?? "";
      phoneController.text = doctor?.phoneNumber ?? "";
      selectedGender.value = doctor?.gender ?? "";
      selectedCountry.value = doctor?.country ?? "";
      selectedSpeciality.value = doctor?.major ?? "";
      selectedLanguages.value = getLanguagesFromDevice();
    }
  }

  Set<String> getLanguagesFromDevice() {
    return {};
  }

  Future<void> fetchDoctorData() async {
    try {
      isLoading.value = true;
      final token = CacheHelper.getData(key: 'token');
      if (token == null) {
        Get.offAllNamed(Routes.DOCTOR_LOGIN);
        return;
      }
      final response = await _doctorProfileApi.getDoctorProfile(token: token);
      doctorData.value = DoctorModel.fromJson(response.data);
      populateFields();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      final token = CacheHelper.getData(key: 'token');
      if (token == null) {
        Get.offAllNamed(Routes.DOCTOR_LOGIN);
        return;
      }
      await _doctorProfileApi.updateDoctorProfile(
        email: emailController.text.trim(),
        token: token,
        fName: firstNameController.text.trim(),
        lName: lastNameController.text.trim(),
        gender: selectedGender.value,
        phoneNumber: phoneController.text.trim(),
        major: selectedSpeciality.value,
        country: selectedCountry.value,
        imagePath: selectedImagePath.value,
      );

      await fetchDoctorData(); // Refresh data

      Get.back(); // Return to profile page
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        isLoading.value = true;
        selectedImagePath.value = image.path;
        await updateProfile();

        Get.snackbar(
          'Success',
          'Profile image updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void changeLanguage() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const CustomText('English'),
              onTap: () => _updateLanguage('en'),
            ),
            ListTile(
              title: const CustomText('العربية'),
              onTap: () => _updateLanguage('ar'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateLanguage(String langCode) {
    Get.back();
    Get.updateLocale(Locale(langCode));
    // Update in preferences if needed
  }

  Future<void> signOut() async {
    try {
      Get.find<DoctorAuthController>().signOut();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void editProfile() {
    Get.toNamed(Routes.EDIT_DOCTOR_PROFILE, arguments: doctorData.value);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}
