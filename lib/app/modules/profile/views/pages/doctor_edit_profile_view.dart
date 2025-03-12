import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_text_widget.dart';
import '../../../../core/widgets/custom_textfield_widget.dart';
import '../../../../core/widgets/custom_button_widget.dart';
import '../../controllers/doctor_profile_controller.dart';

import 'package:med_support_gaza/app/core/utils/countries.dart';
import 'package:med_support_gaza/app/core/utils/medical_specialties.dart';

class DoctorEditProfileView extends GetView<DoctorProfileController> {
  const DoctorEditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        title: CustomText(
          'Edit Profile'.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : Form(
              // Add Form widget here
              key: controller.formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
                child: Column(
                  children: [
                    _buildProfileImage(),
                    24.height,
                    _buildForm(),
                    24.height,
                    _buildProfessionalInfo(),
                    24.height,
                    CustomButton(
                      text: 'Save'.tr,
                      color: AppColors.primary,
                      onPressed: () => controller.updateProfile(),
                    ),
                  ],
                ),
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
              image: controller.doctorData.value?.doctor?.image != null
                  ? DecorationImage(
                      image: NetworkImage(
                          controller.doctorData.value!.doctor?.image ?? ''),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: controller.doctorData.value?.doctor?.image == null
                ? Icon(
                    Icons.person,
                    size: 60.sp,
                    color: Colors.grey[400],
                  )
                : null,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: controller.updateProfileImage,
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
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

  Widget _buildForm() {
    return Column(
      children: [
        CustomTextField(
          controller: controller.firstNameController,
          hintText: 'First Name'.tr,
          prefixIcon: Icons.person_outline,
          validator: (value) => value?.isValidName,
        ),
        16.height,
        CustomTextField(
          controller: controller.lastNameController,
          hintText: 'Last Name'.tr,
          prefixIcon: Icons.person_outline,
          validator: (value) => value?.isValidName,
        ),
        16.height,
        CustomTextField(
          controller: controller.phoneController,
          hintText: 'Phone Number'.tr,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: (value) => value?.isValidPhone,
        ),
        16.height,
        CustomTextField(
          controller: controller.emailController,
          hintText: 'Email'.tr,
          prefixIcon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => value?.isValidEmail,
        ),
        16.height,
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

  Widget _buildProfessionalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Professional Information'.tr,
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
        ),
        16.height,
        GestureDetector(
          onTap: () => _showSpecialityPicker(Get.context!),
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
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                  size: 20.sp,
                ),
                12.width,
                Expanded(
                  child: Obx(() => CustomText(
                        controller.selectedSpeciality.value.isEmpty
                            ? 'Select Speciality'.tr
                            : controller.selectedSpeciality.value,
                        fontSize: 14.sp,
                        color: controller.selectedSpeciality.value.isEmpty
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
        16.height,
        CustomTextField(
          controller: controller.aboutController,
          hintText: 'About'.tr,
          prefixIcon: Icons.info_outline,
        ),
        16.height,
        _buildLanguagesSelection(),
      ],
    );
  }

  Widget _buildLanguagesSelection() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Languages'.tr,
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          8.height,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              _buildLanguageChip('Arabic'),
              _buildLanguageChip('English'),
              _buildLanguageChip('French'),
              // Add more languages as needed
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageChip(String language) {
    return Obx(() {
      final isSelected = controller.selectedLanguages.contains(language);
      return FilterChip(
        label: CustomText(
          language,
          fontSize: 12.sp,
          color: isSelected ? Colors.white : Colors.black,
        ),
        selected: isSelected,
        onSelected: (bool selected) {
          if (selected) {
            controller.selectedLanguages.add(language);
          } else {
            controller.selectedLanguages.remove(language);
          }
        },
        selectedColor: AppColors.primary,
        checkmarkColor: Colors.white,
      );
    });
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
                const Icon(Icons.location_on, color: AppColors.primary),
                12.width,
                CustomText(
                  'Select Country'.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            16.height,
            SizedBox(
              height: Get.height * 0.4,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: countries.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CustomText(countries[index]),
                    onTap: () {
                      controller.selectedCountry.value = countries[index];
                      Get.back();
                    },
                    trailing: Obx(() =>
                        controller.selectedCountry.value == countries[index]
                            ? const Icon(Icons.check_circle,
                                color: AppColors.primary)
                            : const SizedBox()),
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

  void _showSpecialityPicker(BuildContext context) {
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
                const Icon(Icons.medical_services, color: AppColors.primary),
                12.width,
                CustomText(
                  'Select Speciality'.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ],
            ),
            16.height,
            SizedBox(
              height: Get.height * 0.4,
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: medicalSpecialties.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: CustomText(medicalSpecialties[index]),
                    onTap: () {
                      controller.selectedSpeciality.value =
                          medicalSpecialties[index];
                      Get.back();
                    },
                    trailing: Obx(() => controller.selectedSpeciality.value ==
                            medicalSpecialties[index]
                        ? const Icon(Icons.check_circle,
                            color: AppColors.primary)
                        : const SizedBox()),
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
