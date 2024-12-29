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
        padding: const EdgeInsets.all(16.0),
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
              Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  4,
                      (index) => Container(
                    width: 60,
                    margin: const EdgeInsets.symmetric(horizontal: 6),
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
              )),
              // CustomTextField(
              //   hintText: 'Email'.tr,
              //   controller: emailController,
              //   keyboardType: TextInputType.emailAddress,
              //   validator: (value) => value!.isValidEmail,
              // ),
              24.height,
              Obx(
                    () => CustomButton(
                  text: 'Confirm'.tr,
                  color: AppColors.primary,
                  isDisable: controller.isLoading.value,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      controller.forgetPassword(
                        email: emailController.text.trim(),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
