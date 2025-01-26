import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/modules/profile/views/widgets/menu_item_widget.dart';
import '../../controllers/doctor_profile_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class DoctorProfileView extends GetView<DoctorProfileController> {
  const DoctorProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => FirebaseService());
    return Scaffold(
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          :
          // RefreshIndicator(
          //   onRefresh: () => controller.loadDoctorData(),
          //   child:
          SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  40.height,
                  _buildProfileHeader(),
                  _buildDoctorInfo(),
                  _buildSpecialityInfo(),
                  _buildMenuItems(),
                  24.height,
                  CustomButton(
                    text: 'Edit Profile'.tr,
                    color: AppColors.primary,
                    onPressed: () => Get.toNamed(Routes.EDIT_DOCTOR_PROFILE),
                  ),
                  24.height,
                ],
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
                    '${controller.doctorData.value?.firstName ?? ''} ${controller.doctorData.value?.lastName ?? ''}',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  )),
              8.height,
              Obx(() => CustomText(
                    controller.doctorData.value?.email ?? '',
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
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
        border: Border.all(
          color: AppColors.primary,
          width: 2.w,
        ),
        image: controller.doctorData.value?.profileImage != null
            ? DecorationImage(
                image: NetworkImage(controller.doctorData.value!.profileImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: controller.doctorData.value?.profileImage == null
          ? Icon(
              Icons.person,
              size: 60.sp,
              color: Colors.grey[400],
            )
          : null,
    );
  }

  Widget _buildDoctorInfo() {
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
                title: 'Phone'.tr,
                value: controller.doctorData.value?.phoneNo ?? '059659878',
              ),
              12.height,
              _buildInfoItem(
                icon: Icons.medical_services_outlined,
                title: 'Specialty'.tr,
                value: controller.doctorData.value?.speciality ?? 'General',
              ),
              12.height,
              _buildInfoItem(
                icon: Icons.person,
                title: 'Gender'.tr,
                value: controller.doctorData.value?.gender ?? 'Male',
              ),
              12.height,
              _buildInfoItem(
                icon: Icons.location_on,
                title: 'Country'.tr,
                value: controller.doctorData.value?.country ?? 'Egypt',
              ),
            ],
          )),
    );
  }

  Widget _buildSpecialityInfo() {
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Professional Info'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              16.height,
              _buildInfoItem(
                icon: Icons.star,
                title: 'Rating'.tr,
                value: '${controller.doctorData.value?.rating ?? 0.0}',
              ),
              12.height,
              _buildInfoItem(
                icon: Icons.work,
                title: 'Experience'.tr,
                value: '${controller.doctorData.value?.experience ?? 0} years',
              ),
              12.height,
              _buildInfoItem(
                icon: Icons.language,
                title: 'Languages'.tr,
                value: controller.doctorData.value?.languages.join(', ') ??
                    'Arabic',
              ),
              if (controller.doctorData.value?.about.isNotEmpty ?? false) ...[
                12.height,
                _buildInfoItem(
                  icon: Icons.info_outline,
                  title: 'About'.tr,
                  value: controller.doctorData.value?.about ?? '',
                ),
              ],
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
        // MenuItemWidget(
        //   icon: Icons.settings,
        //   title: 'Settings'.tr,
        //   onTap: controller.navigateToSettings,
        // ),
        MenuItemWidget(
          icon: Icons.language,
          title: 'Language'.tr,
          hasDropdown: true,
          onTap: controller.changeLanguage,
        ),
        MenuItemWidget(
          icon: Icons.logout,
          title: 'Sign Out'.tr,
          onTap: controller.signOut,
          isLogout: true,
        ),
      ],
    );
  }
}
