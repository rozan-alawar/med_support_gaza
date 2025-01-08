
// lib/app/modules/profile/views/edit_profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/utils/countries.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/profile_controller.dart';

class PatientEditProfileView extends GetView<ProfileController> {
  const PatientEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          'edit_profile'.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            _buildProfileImage(),
            24.height,
            _buildForm(),
            24.height,
            CustomButton(
              text: 'save'.tr,
              color: AppColors.primary,
              onPressed: () => controller.updateProfile(),
            ),
          ],
        ),
      )),
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
          ),
          Positioned(
            bottom: 0,
            right: 0,
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
        ],
      ),
    );
  }
  Widget _buildForm() {
    return Column(
      children: [
        // First Name
        CustomTextField(
          controller: controller.firstNameController,
          hintText: 'FirstName'.tr,
          prefixIcon: Icons.person_outline,
          validator: (value) => value?.isValidName,
        ),
        16.height,

        // Last Name
        CustomTextField(
          controller: controller.lastNameController,
          hintText: 'LastName'.tr,
          prefixIcon: Icons.person_outline,
          validator: (value) => value?.isValidName,
        ),
        16.height,

        // Phone Number
        CustomTextField(
          controller: controller.phoneController,
          hintText: 'PhoneNumber'.tr,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isValidPhone,
        ),
        16.height,

        // Age
        CustomTextField(
          controller: controller.ageController,
          hintText: 'Age'.tr,
          prefixIcon: Icons.calendar_today_outlined,
          keyboardType: TextInputType.number,
          validator: (value) => value?.isValidAge,
        ),
        16.height,

        // Gender Selection
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Gender'.tr,
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(() => RadioListTile<String>(
                      title: CustomText('Male'.tr),
                      value: 'Male',
                      groupValue: controller.selectedGender.value,
                      onChanged: (value) =>
                      controller.selectedGender.value = value!,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    )),
                  ),
                  Expanded(
                    child: Obx(() => RadioListTile<String>(
                      title: CustomText('Female'.tr),
                      value: 'Female',
                      groupValue: controller.selectedGender.value,
                      onChanged: (value) =>
                      controller.selectedGender.value = value!,
                      activeColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                    )),
                  ),
                ],
              ),
            ],
          ),
        ),
        16.height,

        // Country Selection
        GestureDetector(
          onTap: () => _showCountryPicker(Get.context!),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                12.width,
                Expanded(
                  child: Obx(() => CustomText(
                    controller.selectedCountry.value.isEmpty
                        ? 'Select Country'.tr
                        : controller.selectedCountry.value,
                    fontSize: 14.sp,
                    color: controller.selectedCountry.value.isEmpty
                        ? Colors.grey[600]
                        : Colors.black,
                  )),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[400],
                  size: 16.sp,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showCountryPicker(BuildContext context) {
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
                Icon(Icons.location_on, color: AppColors.primary),
                12.width,
                CustomText(
                  'Select Country'.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            16.height,
            Container(
              height: Get.height * 0.4,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: countries.length,
                separatorBuilder: (context, index) => Divider(height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CustomText(countries[index]),
                    onTap: () {
                      controller.selectedCountry.value = countries[index];
                      Get.back();
                    },
                    trailing: Obx(() => controller.selectedCountry.value == countries[index]
                        ? Icon(Icons.check_circle, color: AppColors.primary)
                        : SizedBox()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}

