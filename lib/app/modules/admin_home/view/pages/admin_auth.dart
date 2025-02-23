import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';

import '../../controller/admin_auth_controller.dart';

class AdminAuth extends GetView<AdminController> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AdminAuth({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 20.h,
            color: AppColors.accent,
          ),
          onPressed: () => Get.back(),
        ),
      ),
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
                60.height,
                Obx(
                  () => CustomButton(
                    text: 'Login'.tr,
                    width: double.infinity,
                    color: controller.isLoading.value
                        ? AppColors.textLight
                        : AppColors.primary,
                    isDisable: controller.isLoading.value,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print('User Logged In');
                        controller.signIn(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim());
                      }
                    },
                  ),
                ),
                24.height,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//email:admin@gmail.com
//password:admin123
