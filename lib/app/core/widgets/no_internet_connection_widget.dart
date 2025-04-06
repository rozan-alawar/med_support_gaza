import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/services/connection_manager_service.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback? onRetry;

  const NoInternetWidget({Key? key, this.onRetry}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // No internet icon
              Icon(
                Icons.wifi_off_rounded,
                size: 80.w,
                color: AppColors.primary.withOpacity(0.7),
              ),
              24.height,
              // Title text
              CustomText(
                'No Internet Connection',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                textAlign: TextAlign.center,
              ),
              12.height,
              // Description text
              CustomText(
                'Please check your internet connection and try again',
                fontSize: 14.sp,
                color: AppColors.textLight,
                textAlign: TextAlign.center,
              ),
              32.height,
              // Retry button
              CustomButton(
                text: 'Retry',
                color: AppColors.primary,
                width: 150.w,
                onPressed: () {
                  if (onRetry != null) {
                    onRetry!();
                  } else {
                    final ConnectionManagerService connectionManager = Get.find<ConnectionManagerService>();
                    connectionManager.init();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}