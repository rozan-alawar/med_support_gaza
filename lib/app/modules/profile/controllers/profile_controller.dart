import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileController extends GetxController {
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