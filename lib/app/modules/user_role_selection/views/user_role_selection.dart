import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/custom_button_widget.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/user_role_selection_controller.dart';

class UserRoleSelectionView extends StatelessWidget {
  final UserRoleSelectionSeController userRoleController =
      Get.put(UserRoleSelectionSeController());
  UserRoleSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageAssets.splash,
              ),
              CustomText(
                'Welcome',
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Arial',
              ),
              15.height,
              CustomText(
                'select_account_type_message',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                textAlign: TextAlign.center,
              ),
              60.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                    onPressed: userRoleController.navigateToDoctor,
                    text: 'doctor'.tr,
                    width: 150,
                    height: 50,
                    color: AppColors.accent,
                    textColor: AppColors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        spreadRadius: 4,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  20.width,
                  CustomButton(
                    borderColor: AppColors.primary,
                    onPressed: userRoleController.navigateToPatient,
                    text: 'patient'.tr,
                    width: 150,
                    height: 50,
                    color: AppColors.white,
                    textColor: AppColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.16),
                        spreadRadius: 4,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                ],
              ),
              150.height
            ],
          ),
        ),
      ),
    );
    ;
  }
}
