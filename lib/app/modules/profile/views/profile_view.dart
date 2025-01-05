import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/profile_controller.dart';
class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            children: [
              _buildProfileImage(),
              SizedBox(height: 24.h),

              // Menu Items
              _buildMenuItem(
                icon: Icons.settings,
                title: 'settings'.tr,
                onTap: () => controller.onSettingsTap(),
              ),
              _buildMenuItem(
                icon: Icons.help_outline,
                title: 'technical_support'.tr,
                onTap: () => controller.onSupportTap(),
              ),
              _buildMenuItem(
                icon: Icons.language,
                title: 'language'.tr,
                hasDropdown: true,
                onTap: () => controller.onLanguageTap(),
              ),
              _buildMenuItem(
                icon: Icons.logout,
                title: 'logout'.tr,
                onTap: () => controller.onLogoutTap(),
                isLogout: true,
              ),
              SizedBox(height: 24.h),

              CustomButton(
                text: 'edit_profile'.tr,
                color: AppColors.primary,
                onPressed: () => controller.onEditProfileTap(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Updated dialog in ProfileController
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
            onPressed: () {
              // Implement logout logic
              Get.offAllNamed('/login');
            },
            child: Text('confirm'.tr),
          ),
        ],
      ),
    );
  }

  // Updated language bottom sheet in ProfileController
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
            Text(
              'select_language'.tr,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            ListTile(
              title: Text('arabic'.tr),
              onTap: () {
                Get.updateLocale(const Locale('ar'));
                Get.back();
              },
            ),
            ListTile(
              title: Text('english'.tr),
              onTap: () {
                Get.updateLocale(const Locale('en'));
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  
  Widget _buildProfileImage() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 120.w,
            height: 120.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[200],
              border: Border.all(
                color: AppColors.primary,
                width: 2.w,
              ),
            ),
            child: Icon(
              Icons.person,
              size: 60.sp,
              color: Colors.grey[400],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () => controller.onChangeProfilePicture(),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool hasDropdown = false,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : AppColors.primary,
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: CustomText(
                title,
                fontSize: 16.sp,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
            if (hasDropdown)
              Icon(
                Icons.arrow_drop_down,
                color: Colors.grey,
                size: 24.sp,
              ),
          ],
        ),
      ),
    );
  }


}