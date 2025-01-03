import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/validation_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/auth_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class PatientResetPasswordView extends GetView<AuthController> {
  final TextEditingController confirmPassController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  PatientResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
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
                  'NewPassword'.tr,
                  fontSize: 20.sp,
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
                60.height,
                CustomTextField(
                  hintText: 'NewPassword'.tr,
                  controller: passwordController,
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isValidPassword,
                ),
                20.height,
                CustomTextField(
                  hintText: 'ConfirmPassword'.tr,
                  controller: confirmPassController,
                  keyboardType: TextInputType.text,
                  validator: (value) => value!.isValidPassword,
                ),
                24.height,
                Obx(
                  () => CustomButton(
                    text: 'Confirm'.tr,
                    color: AppColors.primary,
                    isDisable: controller.isLoading.value,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Get.offNamed(Routes.AUTH);
                      }
                    },
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
