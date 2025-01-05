import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_booking_controller.dart';
// lib/app/modules/appointment_booking/widgets/specialization_widget.dart
class SpecializationWidget extends GetView<AppointmentBookingController> {
  final String title;
  final dynamic availableDoctors;
  final VoidCallback onTap;

  const SpecializationWidget({
    super.key,
    required this.title,
    required this.availableDoctors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: controller.selectedSpecialization.value == title
                ?  AppColors.primary
                : Colors.transparent,
            width: 2.w,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.16),
              blurRadius: 4,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              title,
              fontSize: 13.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D2D2D),
            ),
            6.height,
            Row(
              children: [
                CustomText(
                  'AvailableDoctors'.tr,
                  fontSize: 11.sp,
                ),
                4.width,
                CustomText(
                  availableDoctors.toString(),
                  fontSize: 11.sp,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}