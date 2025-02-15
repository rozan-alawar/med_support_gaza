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
import '../controllers/auth_controller.dart';

class PatientLoginView extends GetView<AuthController> {
  PatientLoginView({super.key});

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
            child: Stack(
              children: [
                _buildLoginForm(),
                _buildLoadingIndicator(),
              ],
            ),
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
        validator: (value) => value!.isValidPassword,
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
        onTap: () => Get.toNamed(Routes.FORGET_PASSWORD),
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

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      controller.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
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
          onTap: controller.toggleView,
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
