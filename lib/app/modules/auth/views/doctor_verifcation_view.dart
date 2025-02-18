import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/doctro_auth_controller.dart';

class DoctorVerifcationView extends GetView<DoctorAuthController> {
  final _formKey = GlobalKey<FormState>();

  DoctorVerifcationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              100.height,
              CustomText(
                'EnterOTP'.tr,
                fontSize: 20.sp,
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
              40.height,
              _OTPInputFields(
                controller: controller,
                formKey: _formKey,
              ),
              40.height,
              _VerifyButton(
                controller: controller,
                formKey: _formKey,
              ),
              16.height,
              _ResendTimerSection(controller: controller),
            ],
          ),
        ),
      ),
    );
  }
}

class _OTPInputFields extends StatelessWidget {
  final DoctorAuthController controller;
  final GlobalKey<FormState> formKey;

  static const int otpLength = 4;
  static const double inputWidth = 60;
  static const double inputMargin = 10;

  const _OTPInputFields({
    required this.controller,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          otpLength,
          (index) => Container(
            width: inputWidth,
            margin: const EdgeInsets.symmetric(horizontal: inputMargin),
            child: TextFormField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 1,
              onChanged: (value) {
                if (value.length == 1) {
                  controller.setDigit(index, value);
                  if (index < otpLength - 1) {
                    FocusScope.of(context).nextFocus();
                  } else {
                    FocusScope.of(context).unfocus();
                    if (formKey.currentState?.validate() ?? false) {
                      controller.verifyOTP();
                    }
                  }
                }
              },
              decoration: InputDecoration(
                counterText: '',
                enabledBorder: _buildInputBorder(Colors.grey, 1),
                focusedBorder: _buildInputBorder(AppColors.primary, 2),
                errorBorder: _buildInputBorder(Colors.red, 1),
                focusedErrorBorder: _buildInputBorder(Colors.red, 2),
              ),
              validator: (value) =>
                  value?.isEmpty == true ? 'Required'.tr : null,
            ),
          ),
        ),
      ),
    );
  }

  OutlineInputBorder _buildInputBorder(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(
        color: color,
        width: width,
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  final DoctorAuthController controller;
  final GlobalKey<FormState> formKey;

  const _VerifyButton({
    required this.controller,
    required this.formKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomButton(
        text: 'Verify'.tr,
        color: AppColors.primary,
        isDisable: controller.isLoading.value,
        onPressed: () {
          if (formKey.currentState?.validate() ?? false) {
            controller.verifyOTP();
          }
        },
      ),
    );
  }
}

class _ResendTimerSection extends StatelessWidget {
  final DoctorAuthController controller;

  const _ResendTimerSection({
    required this.controller,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(
            () => !controller.canResend.value
                ? Text(
                    '00:${controller.timeRemaining.value.toString().padLeft(2, '0')}',
                    style: const TextStyle(color: Colors.grey),
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => TextButton(
              onPressed: controller.canResend.value
                  ? controller.handleResendOTP
                  : null,
              child: Text(
                'Resend OTP'.tr,
                style: TextStyle(
                  color: controller.canResend.value
                      ? AppColors.primary
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
