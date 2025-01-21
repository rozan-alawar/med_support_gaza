import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

import '../utils/app_colors.dart';
import 'custom_button_widget.dart';

class CustomAppointmentCard extends StatelessWidget {
  final String patientName;
  final String date;
  final String time;
  final String butText;
  void Function()? onPressed;
  CustomAppointmentCard({super.key, 
    required this.patientName,
    required this.date,
    required this.time,
    required this.butText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      height: 160.h,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            patientName,
            fontFamily: 'LamaSans',
            fontSize: 14.sp,
          ),
          8.height,
          CustomText(
            date,
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          8.height,
          CustomText(
            time,
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          Align(
            alignment: Get.locale?.languageCode == 'ar'
                ? Alignment.bottomLeft
                : Alignment.bottomRight,
            child: CustomButton(
              borderColor: AppColors.error,
              onPressed: onPressed,
              text: butText,
              fontSize: 8.sp,
              textColor: AppColors.textDark,
              width: 100.w,
              height: 40.h,
              color: AppColors.white,
            ),
          ),
        ],
      ),
    );
  }
}
