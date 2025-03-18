import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/doctro_auth_controller.dart';
import '../../../core/utils/countries.dart';
import '../../../core/utils/medical_specialties.dart';
import '../../../routes/app_pages.dart';

class DoctorSignUpView extends GetView<DoctorAuthController> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController specialityController = TextEditingController();
  final TextEditingController uploadFileController = TextEditingController();

  final RxString gender = 'Male'.obs;
  DoctorSignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
        ),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                100.height,
                CustomText(
                  'SignUp'.tr,
                  fontSize: 20.sp,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
                30.height,
                CustomTextField(
                  hintText: 'FirstName'.tr,
                  controller: firstNameController,
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isValidName,
                ),
                16.height,
                CustomTextField(
                  hintText: 'LastName'.tr,
                  controller: lastNameController,
                  validator: (value) => value!.isValidName,
                  keyboardType: TextInputType.text,
                ),
                16.height,
                CustomTextField(
                  hintText: 'Email'.tr,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isValidEmail,
                ),
                16.height,
                GestureDetector(
                  onTap: () {
                    //showCountriesList(context);
                    _showCountryPicker(context);
                  },
                  child: AbsorbPointer(
                    child: CustomTextField(
                      readOnly: true,
                      hintText: 'country'.tr,
                      controller: countryController,
                      keyboardType: TextInputType.text,
                      validator: (value) => value!.isValidCountryName,
                    ),
                  ),
                ),
                16.height,
                Obx(
                  () => CustomTextField(
                    hintText: 'Password'.tr,
                    controller: passwordController,
                    obscureText: controller.isPasswordVisible.value,
                    validator: (value) => value!.isValidPassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        size: 18.h,
                        controller.isPasswordVisible.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => controller.togglePasswordVisibility(),
                    ),
                  ),
                ),
                16.height,
                Obx(
                  () => CustomTextField(
                    hintText: 'ConfirmPassword'.tr,
                    controller: confirmPasswordController,
                    obscureText: controller.isPasswordVisible2.value,
                    validator: (value) {
                      if (value == null) {
                        return 'enter_password'.tr;
                      } else if (passwordController.text.compareTo(value) !=
                          0) {
                        return 'confirmation_maessage'.tr;
                      }
                      return null;
                    },
                    suffixIcon: IconButton(
                      icon: Icon(
                        size: 18.h,
                        controller.isPasswordVisible2.value
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () => controller.togglePasswordVisibility2(),
                    ),
                  ),
                ),
                16.height,
                CustomTextField(
                  hintText: 'PhoneNumber'.tr,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isValidPhone,
                ),
                16.height,
                GestureDetector(
                    onTap: () {
                      // showSpecialtyList(context);
                      _showSpecialityPicker(context);
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        readOnly: true,
                        hintText: 'speciality'.tr,
                        controller: specialityController,
                        keyboardType: TextInputType.text,
                        validator: (value) => value!.isValidSpecialtyName,
                      ),
                    )),
                16.height,
                Obx(() {
                  return AbsorbPointer(
                    absorbing: false,
                    child: CustomTextField(
                      readOnly: true,
                      validator: (value) => value!.isValidfileName,
                      hintText: 'upload_medical_certificate'.tr,
                      controller: uploadFileController,
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isUploading.value
                              ? Icons.close
                              : Icons.file_upload_outlined,
                          size: 18.h,
                        ),
                        onPressed: () async {
                          await controller.pickFile(uploadFileController);
                        },
                      ),
                    ),
                  );
                }),
                16.height,
                CustomTextField(
                  hintText: 'Age'.tr,
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  validator: (value) => value!.isValidAge,
                ),
                16.height,
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: CustomText('Gender'.tr,
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    Obx(() => Radio(
                          activeColor: AppColors.primary,
                          value: 'male',
                          groupValue: gender.value,
                          onChanged: (value) => gender.value = value.toString(),
                        )),
                    CustomText('Male'.tr),
                    Obx(() => Radio(
                          value: 'female',
                          activeColor: AppColors.primary,
                          groupValue: gender.value,
                          onChanged: (value) => gender.value = value.toString(),
                        )),
                    CustomText('Female'.tr),
                  ],
                ),
                30.height,
                Obx(
                  () => CustomButton(
                    text: 'SignUp'.tr,
                    color: controller.isLoading.value
                        ? AppColors.textLight
                        : AppColors.primary,
                    isDisable: controller.isLoading.value,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        controller.signUp(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                          passwordConfirmation:
                              confirmPasswordController.text.trim(),
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          phone: phoneController.text.trim(),
                          country: countryController.text.trim(),
                          specialty: specialityController.text.trim(),
                          gender: gender.value,
                        );

                        // File? documentFile;
                        // if (controller.selectedFilePath.value.isNotEmpty) {
                        //   documentFile =
                        //       File(controller.selectedFilePath.value);
                        // }
                        // await controller.signUp(
                        //   email: emailController.text.trim(),
                        //   password: passwordController.text.trim(),
                        //   firstName: firstNameController.text.trim(),
                        //   lastName: lastNameController.text.trim(),
                        //   phone: phoneController.text.trim(),
                        //   country: countryController.text.trim(),
                        //   specialty: specialityController.text.trim(),
                        //   documentFile: documentFile,
                        //   age: ageController.text.trim(),
                        //   gender: gender.value,
                        // );
                      }
                    },
                  ),
                ),
                24.height,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        fontSize: 11.sp,
                        'AlreadyHaveAccount'.tr,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.offNamed(Routes.DOCTOR_LOGIN);
                        },
                        child: CustomText(
                          fontSize: 11.sp,
                          'SignIn'.tr,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                40.height,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showSpecialtyList(BuildContext context) {
    // When tapped, show the dropdown
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: CustomText(
              'Select Specialty',
              fontSize: 18.sp,
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: medicalSpecialties.map((specialty) {
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        specialty,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    onTap: () {
                      specialityController.text = specialty;
                      Navigator.pop(context);
                    },
                  );
                }).toList(),
              ),
            ));
      },
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
                        controller.medicalSpecialty.value =
                            medicalSpecialties[index];
                        specialityController.text = medicalSpecialties[index];
                        Get.back();
                      },
                      trailing: Obx(
                        () => controller.medicalSpecialty.value ==
                                medicalSpecialties[index]
                            ? const Icon(Icons.check_circle,
                                color: AppColors.primary)
                            : const SizedBox(),
                      ));
                },
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  void showCountriesList(BuildContext context) {
    // When tapped, show the dropdown
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: CustomText(
              'Select Country',
              fontSize: 18.sp,
              color: AppColors.accent,
              fontWeight: FontWeight.bold,
            ),
            content: SingleChildScrollView(
              child: Column(
                children: countries.map((country) {
                  return ListTile(
                    title: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        country,
                        textAlign: TextAlign.left,
                      ),
                    ),
                    onTap: () {
                      countryController.text = country;
                      Get.back();
                    },
                  );
                }).toList(),
              ),
            ));
      },
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
                      countryController.text = countries[index];
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
}
