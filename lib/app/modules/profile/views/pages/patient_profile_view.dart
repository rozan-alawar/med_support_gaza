import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/profile_controller.dart';
import 'package:med_support_gaza/app/modules/profile/views/widgets/menu_item_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
class PatientProfileView extends GetView<ProfileController> {
  const PatientProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>ProfileController());
    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: () => controller.getProfile()
        ,
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              40.height,
              _buildProfileHeader(),
              24.height,
              _buildUserInfo(),
              24.height,
              _buildMenuItems(),
              24.height,
              CustomButton(
                text: 'edit_profile'.tr,
                color: AppColors.primary,
                onPressed: () => Get.toNamed(Routes.EDIT_PATIENT_PROFILE),
              ),
              24.height,
            ],
          ),
        ),
      )),
    );
  }

  Widget _buildProfileHeader() {
    return Stack(
      children: [
        Center(
          child: Column(
            children: [
              _buildProfileImage(),
              16.height,
              Obx(() => CustomText(
                '${controller.currentUser.value?.firstName ?? ''} ${controller.currentUser.value?.lastName ?? ''}',
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              )),
              8.height,
              Obx(() => CustomText(
                controller.currentUser.value?.email.toString() ?? '',
                fontSize: 14.sp,
                color: Colors.grey[600],
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProfileImage() {
    return Container(
      width: 100.w,
      height: 100.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
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
    );
  }

  Widget _buildUserInfo() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Obx(() => Column(
        children: [
          _buildInfoItem(
            icon: Icons.phone,
            title: 'phone'.tr,
            value: controller.currentUser.value?.phoneNumber ?? '',
          ),
          12.height,
          _buildInfoItem(
            icon: Icons.cake,
            title: 'age'.tr,
            value: controller.currentUser.value?.age.toString() ?? '',
          ),
          12.height,
          _buildInfoItem(
            icon: Icons.person,
            title: 'gender'.tr,
            value: controller.currentUser.value?.gender ?? '',
          ),
          12.height,
          _buildInfoItem(
            icon: Icons.location_on,
            title: 'country'.tr,
            value: controller.currentUser.value?.address ?? '',
          ),
        ],
      )),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20.sp),
        ),
        12.width,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                title,
                fontSize: 12.sp,
                color: Colors.grey[600],
              ),
              4.height,
              CustomText(
                value,
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        // _buildMenuItem(
        //   icon: Icons.settings,
        //   title: 'settings'.tr,
        //   onTap: () {},
        // ),
        MenuItemWidget(
          icon: Icons.language,
          title: 'language'.tr,
          hasDropdown: true,
          onTap: () => controller.onLanguageTap(),
        ),
        MenuItemWidget(
          icon: Icons.logout,
          title: 'logout'.tr,
          onTap: () => controller.onLogoutTap(),
          isLogout: true,
        ),
      ],
    );
  }

}