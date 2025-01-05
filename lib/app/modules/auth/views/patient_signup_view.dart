import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import '../controllers/auth_controller.dart';

class PatientSignUpView extends GetView<AuthController> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final RxString gender = 'Male'.obs;
  PatientSignUpView({super.key});

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
                CustomTextField(
                  hintText: 'PhoneNumber'.tr,
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  validator: (value) => value!.isValidPhone,
                ),
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
                          value: 'Male',
                          groupValue: gender.value,
                          onChanged: (value) => gender.value = value.toString(),
                        )),
                    CustomText('Male'.tr),
                    Obx(() => Radio(
                          value: 'Female',
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
                    color: AppColors.primary,
                    isDisable: controller.isLoading.value,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        controller.signUp(
                          password: passwordController.text.trim(),
                          email: emailController.text.trim(),
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          phoneNo: phoneController.text.trim(),
                          age: ageController.text.trim(),
                          gender: gender.value.toString(),
                          country: 'Gaza'
                        );
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
                        onTap: controller.toggleView,
                        child: CustomText(
                          fontSize: 11.sp,
                          'SignIn'.tr,
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
