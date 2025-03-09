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

class DoctroResetPasswordView extends GetView<DoctorAuthController> {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DoctroResetPasswordView({super.key});

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
                  'NewPassword'.tr,
                  fontSize: 20.sp,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
                64.height,
                Obx(
                  () => CustomTextField(
                    hintText: 'NewPassword'.tr,
                    controller: newPasswordController,
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
                20.height,
                Obx(
                  () => CustomTextField(
                    hintText: 'ConfirmPassword'.tr,
                    controller: passwordController,
                    obscureText: controller.isPasswordVisible2.value,
                    validator: (value) {
                      if (value == null) {
                        return 'enter_password'.tr;
                      } else if (newPasswordController.text.compareTo(value) !=
                          0) {
                        return  'confirmation_maessage'.tr;
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
                64.height,
                CustomButton(
                  text: 'Confirm'.tr,
                  width: double.infinity,
                  color: AppColors.primary,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.resetPassword(
                        email: '',
                        newPassword: newPasswordController.text,
                        confirmPassword: passwordController.text,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
