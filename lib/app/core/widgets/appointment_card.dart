import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

import '../utils/app_colors.dart';
import 'custom_button_widget.dart';

class AppointmentCard extends StatelessWidget {
  final String patientName;
  final String date;
  final String time;

  AppointmentCard(
      {required this.patientName, required this.date, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.gray),
          borderRadius: BorderRadius.all(Radius.circular(10.r))),
      width: 160.w,
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
      child: Column(
        children: [
          CustomText(
            patientName,
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          10.height,
          CustomText(
            '$date - $time',
            fontFamily: 'LamaSans',
            fontSize: 12.sp,
          ),
          20.height,
          CustomButton(
            text: 'الموعد',
            fontSize: 10.sp,
            color: AppColors.primary,
            onPressed: () {},
            width: 60.w,
            height: 40.h,
          ),
        ],
      ),
    );
  }
}

// class AppointmentCardWithStatus extends StatelessWidget {
//   final String patientName;
//   final String date;
//   final String time;
//   final String Status;

//   AppointmentCardWithStatus(
//       {required this.patientName, required this.date, required this.time , required this.Status});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           border: Border.all(color: AppColors.gray),
//           borderRadius: BorderRadius.all(Radius.circular(10.r))),
//       width: 160.w,
//       margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//       padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.h),
//       child: Column(
//         children: [
//           CustomText(
//             patientName,
//             fontFamily: 'LamaSans',
//             fontSize: 12.sp,
//           ),
//           10.height,
//           CustomText(
//             '$date - $time',
//             fontFamily: 'LamaSans',
//             fontSize: 12.sp,
//           ),
//           20.height,
          
//           CustomButton(
//             text: 'الموعد',
//             fontSize: 10.sp,
//             color: AppColors.primary,
//             onPressed: () {},
//             width: 60.w,
//             height: 40.h,
//           ),
//         ],
//       ),
//     );
//   }
// }
