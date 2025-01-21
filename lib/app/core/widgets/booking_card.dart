import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';

import '../utils/app_colors.dart';
import 'custom_button_widget.dart';
import 'custom_text_widget.dart';

class BookingCard extends StatelessWidget {
  final String patientName;
  final String date;
  final String time;
  void Function()? onApprove;
  void Function()? onReject;

  BookingCard(
      {super.key, required this.patientName,
      required this.date,
      required this.time,
      this.onApprove,
      this.onReject});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      width: 160.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            patientName,
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          10.height,
          CustomText(
            date,
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          10.height,
          CustomText(
            time,
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          20.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: 'Approve'.tr,
                fontSize: 10.sp,
                color: AppColors.primary,
                onPressed: onApprove,
                width: 60.w,
                height: 40.h,
              ),
              20.width,
              CustomButton(
                text: 'Reject'.tr,
                fontSize: 10.sp,
                color: AppColors.error,
                onPressed: onReject,
                width: 60.w,
                height: 40.h,
              ),
            ],
          )
        ],
      ),
    );
  }
}
