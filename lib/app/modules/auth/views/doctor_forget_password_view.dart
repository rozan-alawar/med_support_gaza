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
import 'package:med_support_gaza/app/routes/app_pages.dart';

class DoctorForgetPasswordView extends GetView<DoctorAuthController> {
  DoctorForgetPasswordView({super.key});

  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: _buildAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Stack(
              children: [
                _buildForgetPasswordForm(),
                _buildLoadingIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.transparent,
      elevation: 0,
    );
  }

  Widget _buildForgetPasswordForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        200.height,
        _buildTitle(),
        60.height,
        _buildEmailField(),
        24.height,
        _buildSendOTPButton(),
      ],
    );
  }

  Widget _buildTitle() {
    return CustomText(
      'ForgotPassword'.tr,
      fontSize: 20.sp,
      color: AppColors.accent,
      fontWeight: FontWeight.bold,
    );
  }

  Widget _buildEmailField() {
    return CustomTextField(
      hintText: 'Email'.tr,
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => value!.isValidEmail,
    );
  }

  Widget _buildSendOTPButton() {
    return Obx(
      () => CustomButton(
        text: 'Send OTP'.tr,
        color: AppColors.primary,
        isDisable: controller.isLoading.value,
        onPressed: _handleSendOTP,
      ),
    );
  }

  void _handleSendOTP() {
    if (_formKey.currentState!.validate()) {
      controller.forgetPasswordInit(
        email: _emailController.text.trim(),
      ).then((_) {
        if (!controller.hasError.value) {
          Get.toNamed(Routes.DOCTOR_VERIFICATION);
        }
      });
    }
  }

  Widget _buildLoadingIndicator() {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink(),
    );
  }
}
