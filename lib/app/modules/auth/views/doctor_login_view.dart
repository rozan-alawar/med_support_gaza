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

class DoctorLoginView extends GetView<DoctorAuthController> {
  DoctorLoginView({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: _buildLoginForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        200.height,
        _buildTitle(),
        64.height,
        _buildEmailField(),
        20.height,
        _buildPasswordField(),
        12.height,
        _buildForgotPasswordButton(),
        60.height,
        _buildLoginButton(),
        24.height,
        _buildSignUpRow(),
      ],
    );
  }

  Widget _buildTitle() {
    return CustomText(
      'Login'.tr,
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

  Widget _buildPasswordField() {
    return Obx(
      () => CustomTextField(
        hintText: 'Password'.tr,
        controller: _passwordController,
        obscureText: controller.isPasswordVisible.value,
        suffixIcon: IconButton(
          icon: Icon(
            controller.isPasswordVisible.value
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            size: 18.h,
          ),
          onPressed: controller.togglePasswordVisibility,
        ),
      ),
    );
  }

  Widget _buildForgotPasswordButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.DOCTOR_FORGET_PASSWORD),
        child: CustomText(
          'ForgotPassword'.tr,
          color: AppColors.primary,
          fontSize: 11.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return Obx(
      () => CustomButton(
        text: 'Login'.tr,
        width: double.infinity,
        color: controller.isLoading.value
            ? AppColors.textLight
            : AppColors.primary,
        isDisable: controller.isLoading.value,
        onPressed: _handleLogin,
      ),
    );
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text.trim();
      String password = _passwordController.text.trim();
      try {
        await controller.signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        _emailController.text = email;
        _passwordController.text = password;
      } catch (e) {
        _emailController.text = email;
        _passwordController.text = password;
      }
    }
  }

  Widget _buildSignUpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(
          fontSize: 11.sp,
          'DontHaveAccount'.tr,
        ),
        GestureDetector(
          onTap: () => Get.offNamed(Routes.DOCTOR_SIGNUP),
          child: CustomText(
            fontSize: 11.sp,
            'CreateAccountNow'.tr,
            color: AppColors.accent,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : const SizedBox.shrink(),
    );
  }
}
