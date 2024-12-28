import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              50.height,
              Image.asset(
                ImageAssets.doctros,
              ),
              45.height,
              Text(
                'doctor_team_welcome_message'.tr,
                style: MyTextStyles.headingBoldLarge,
              ),
              20.height,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Text(
                  'welcome_doctor_message'.tr,
                  style: MyTextStyles.bodyRegularCentered,
                  textAlign: TextAlign.center,
                ),
              ),
              100.height,
              CustomButton(
                onPressed: () {
                  Get.offNamed(Routes.HOME);
                },
                text: 'next'.tr,
                color: AppColors.primary,
                width: 298.w,
                height: 50.h,
                borderRadius: BorderRadius.circular(5).r,
              ),
              40.height
            ],
          ),
        ),
      ),
    );
  }
}
