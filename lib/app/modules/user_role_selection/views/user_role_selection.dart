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
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageAssets.splash,
              ),
              const CustomText(
                'Welcome',
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontFamily: 'Arial',
              ),
              15.height,
              const CustomText(
                'select_account_type_message',
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Arial',
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
                    color: AppColors.white,
                    textColor: AppColors.textLight,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  20.width,
                  CustomButton(
                    onPressed: userRoleController.navigateToPatient,
                    text: 'patient'.tr,
                    width: 150,
                    height: 50,
                    color: AppColors.white,
                    textColor: AppColors.textLight,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        spreadRadius: 1,
                        blurRadius: 5,
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
