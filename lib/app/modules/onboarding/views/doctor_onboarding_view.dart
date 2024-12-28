import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_text_style.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../../../routes/app_pages.dart';

class DoctorOnboardingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 40.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              50.height,
              Image.asset(
                ImageAssets.doctros,
                fit: BoxFit.fitWidth,
                width: 317.w,
              ),
              45.height,
              CustomText(
                'doctor_team_welcome_message'.tr,
                color: AppColors.accent,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              30.height,
              CustomText(
                'welcome_doctor_message'.tr,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w500,
              ),
              100.height,
              CustomButton(
                onPressed: () {
                  Get.offNamed(Routes.HOME);
                },
                text: 'next'.tr,
                color: AppColors.primary,
              ),
              40.height
            ],
          ),
        ),
      ),
    );
  }
}
