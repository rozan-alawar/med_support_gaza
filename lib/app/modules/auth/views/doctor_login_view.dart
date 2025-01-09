import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
import '../controllers/doctor_auth_controller.dart';

class DoctroLoginView extends GetView<DoctorAuthController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DoctroLoginView({super.key});

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
                200.height,
                CustomText(
                  'Login'.tr,
                  fontSize: 20.sp,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
                64.height,
                CustomTextField(
                  hintText: 'Email'.tr,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value!.isValidEmail,
                ),
                20.height,
                Obx(
                  () => CustomTextField(
                    hintText: 'Password'.tr,
                    controller: passwordController,
                    obscureText: controller.isPasswordVisible.value,
                    // validator: (value) => value!.isValidPassword,
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
                12.height,
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.DOCTOR_FORGET_PASSWORD);
                    },
                    child: CustomText(
                      'ForgotPassword'.tr,
                      color: AppColors.primary,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                60.height,
                CustomButton(
                  text: 'Login'.tr,
                  width: double.infinity,
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      print('doctor is logged in ');
                      Get.offNamed(Routes.DOCTOR_HOME);
                    }
                  },
                ),
                24.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      fontSize: 11.sp,
                      'DontHaveAccount'.tr,
                    ),
                    GestureDetector(
                      onTap:() {
                          Get.offNamed(Routes.DOCTOR_SIGNUP);
                        },
                      child: CustomText(
                        fontSize: 11.sp,
                        'CreateAccountNow'.tr,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
