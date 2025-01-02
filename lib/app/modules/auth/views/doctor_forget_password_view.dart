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

import '../controllers/doctro_auth_controller.dart';

class DoctorForgetPasswordView extends GetView<DoctorAuthController> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DoctorForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              200.height,
              CustomText(
                'ForgotPassword'.tr,
                fontSize: 20.sp,
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
              60.height,
              CustomTextField(
                hintText: 'Email'.tr,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isValidEmail,
              ),
              24.height,
              CustomButton(
                text: 'Send OTP'.tr,
                color: AppColors.primary,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                  //  Get.offNamed(Routes.DOCTOR_FORGET_PASSWORD);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
