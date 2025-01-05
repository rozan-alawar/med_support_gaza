import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_assets.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_booking_controller.dart';

class DoctorCard extends GetView<AppointmentBookingController> {
  final String name;
  final String specialization;
  final double rating;
  final String experience;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialization,
    required this.rating,
    required this.experience,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: controller.selectedDoctor.value == name
                    ? AppColors.primary
                    : Colors.transparent,
                width: 2.w,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.14),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: const Offset(2, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Image.asset(
                  ImageAssets.doctros,
                  width: 75.w,
                  height: 75.w,
                  fit: BoxFit.fill,
                ),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        name,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      6.height,
                      CustomText(
                        specialization,
                        fontSize: 12.sp,
                        color: Colors.grey[600],
                      ),
                      8.height,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.star,
                            size: 16.sp,
                            color: Colors.amber,
                          ),
                          4.width,
                          CustomText(
                            rating.toString(),
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                          16.width,
                          Icon(
                            Icons.work_outline,
                            size: 16.sp,
                            color: AppColors.primary,
                          ),
                          4.width,
                          CustomText(
                            experience,
                            fontSize: 11.sp,
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16.sp,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ));
  }
}
