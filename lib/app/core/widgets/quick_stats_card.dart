import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

class QuickStatsCard extends StatelessWidget {
  final int unreadMessages;

  QuickStatsCard({required this.unreadMessages});

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
          10.height,
          CustomText(
            'Number of unread messages'.tr,
            fontFamily: 'LamaSans',
            fontSize: 14.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
          20.height,
          CustomText(
            '$unreadMessages ${'Unread message from patients'.tr}',
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          20.height,
          Align(
            alignment: Alignment.bottomLeft,
            child: CustomButton(
              fontSize: 10.sp,
              color: AppColors.primary,
              onPressed: () {},
              width: 100.w,
              height: 40.h,
              text: 'Show details'.tr,
            ),
          ),
        ],
      ),
    );
  }
}

