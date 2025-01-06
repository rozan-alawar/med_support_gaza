
// lib/app/modules/profile/views/edit_profile_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/profile_controller.dart';

class PatientEditProfileView extends GetView<ProfileController> {
  const PatientEditProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          'edit_profile_title'.tr,
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildProfileImage(),
              30.height,
              CustomTextField(
                hintText: 'first_name'.tr,
                controller: controller.firstNameController,
                keyboardType: TextInputType.text,
                validator: (value) => value!.isValidName,
              ),
              16.height,
              CustomTextField(
                hintText: 'last_name'.tr,
                controller: controller.lastNameController,
                validator: (value) => value!.isValidName,
                keyboardType: TextInputType.text,
              ),
              16.height,
              CustomTextField(
                hintText: 'email'.tr,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isValidEmail,
              ),
              16.height,
              CustomTextField(
                hintText: 'address'.tr,
                controller: controller.addressController,
                keyboardType: TextInputType.text,
              ),
              16.height,
              CustomTextField(
                hintText: 'phone'.tr,
                controller: controller.phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isValidPhone,
              ),
              16.height,
              CustomTextField(
                hintText: 'age'.tr,
                controller: controller.ageController,
                keyboardType: TextInputType.number,
                validator: (value) => value!.isValidAge,
              ),
              16.height,
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: CustomText(
                  'gender'.tr,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Obx(() => Row(
                children: [
                  Radio(
                    activeColor: AppColors.primary,
                    value: 'male',
                    groupValue: controller.gender.value,
                    onChanged: (value) => controller.gender.value = value.toString(),
                  ),
                  CustomText('male'.tr),
                  Radio(
                    value: 'female',
                    activeColor: AppColors.primary,
                    groupValue: controller.gender.value,
                    onChanged: (value) => controller.gender.value = value.toString(),
                  ),
                  CustomText('female'.tr),
                ],
              )),
              30.height,
              Obx(() => CustomButton(
                text: 'save_changes'.tr,
                color: AppColors.primary,
                isDisable: controller.isLoading.value,
                onPressed: controller.updateProfile,
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 60.r,
          backgroundColor: Colors.grey[200],
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
            onTap: controller.changeProfilePicture,
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
    );
  }
}