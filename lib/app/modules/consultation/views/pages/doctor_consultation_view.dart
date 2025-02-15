import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

import '../../../../core/utils/app_colors.dart';
import '../../controllers/doctor_consultation_controller.dart';

class DoctorConsultationView extends GetView<DoctorConsultationController> {
  const DoctorConsultationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Row(
          children: [
            CircleAvatar(
                radius: 20.r,
                backgroundColor: const Color(0xffEEEEEE),
                child: Icon(
                  Icons.person,
                  color: AppColors.textLight,
                  size: 25.sp,
                )),
            12.width,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  "saja",
                  color: Colors.white,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  "Online",
                  color: Colors.white70,
                  fontSize: 12.sp,
                ),
              ],
            ),
          ],
        ),
      ),
      body: const Center(
        child: Column(
          children: [CustomText('chat')],
        ),
      ),
    );
  }
}
