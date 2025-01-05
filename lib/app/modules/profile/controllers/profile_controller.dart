import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final isLoading = false.obs;
  final gender = 'male'.obs;

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController addressController;
  late TextEditingController phoneController;
  late TextEditingController ageController;

  @override
  void onInit() {
    super.onInit();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    addressController = TextEditingController();
    phoneController = TextEditingController();
    ageController = TextEditingController();
    loadUserData();
  }

  void loadUserData() {
    // Load user data from your data source (e.g., Firebase)
    // For now, we'll use dummy data
    firstNameController.text = 'John';
    lastNameController.text = 'Doe';
    emailController.text = 'john.doe@example.com';
    addressController.text = '123 Main St';
    phoneController.text = '1234567890';
    ageController.text = '30';
    gender.value = 'male';
  }

  void changeProfilePicture() {
    Get.dialog(
      AlertDialog(
        title: Text('change_profile_picture'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('take_photo'.tr),
              onTap: () {
                // Implement camera functionality
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('choose_from_gallery'.tr),
              onTap: () {
                // Implement gallery functionality
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;
      // Implement your update logic here
      await Future.delayed(Duration(seconds: 2)); // Simulate API call

      Get.snackbar(
        'Success',
        'update_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    addressController.dispose();
    phoneController.dispose();
    ageController.dispose();
    super.onClose();
  }
  void onChangeProfilePicture() {
    // Implement image picker logic
    Get.dialog(
      // Image selection dialog
      AlertDialog(
        title: const Text('تغيير الصورة الشخصية'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط صورة'),
              onTap: () {
                // Handle camera selection
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                // Handle gallery selection
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void onSettingsTap() {
    // Navigate to settings screen
    Get.toNamed('/settings');
  }

  void onSupportTap() {
    // Navigate to support screen
    Get.toNamed('/support');
  }

  void onLanguageTap() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.r),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                // Change to Arabic
                Get.back();
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                // Change to English
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  void onLogoutTap() {
    Get.dialog(
      AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () {
              // Implement logout logic
              Get.offAllNamed('/login');
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }

  void onEditProfileTap() {
    // Navigate to edit profile screen
    Get.toNamed('/edit-profile');
  }
}