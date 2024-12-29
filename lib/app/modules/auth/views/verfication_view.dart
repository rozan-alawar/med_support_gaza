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

class VerificationView extends GetView<AuthController> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              200.height,
              CustomText(
                'EnterOTP'.tr,
                fontSize: 20.sp,
                color: AppColors.accent,
                fontWeight: FontWeight.bold,
              ),
              60.height,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 60,

                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        maxLength: 1,
                        onChanged: (value) {
                          controller.setDigit(index, value);
                          if (value.isNotEmpty && index < 3) {
                            FocusScope.of(context).nextFocus();
                          }
                        },
                        initialValue: controller.otpDigits[index],
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFF009688),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              60.height,
              Obx(
                () => CustomButton(
                  text: 'Confirm'.tr,
                  color: AppColors.primary,
                  isDisable: controller.isLoading.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.verifyOTP();
                    }
                  },
                ),
              ),
              const SizedBox(height: 16),
              // Resend Timer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() => !controller.canResend.value
                      ? Text(
                          '00:${controller.timeRemaining.value.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        )
                      : const SizedBox()),
                  Obx(() => TextButton(
                        onPressed: controller.canResend.value
                            ? controller.resendOTP
                            : null,
                        child: Text(
                          'ارسل OTP مرة أخرى',
                          style: TextStyle(
                            color: controller.canResend.value
                                ? const Color(0xFF009688)
                                : Colors.grey,
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
