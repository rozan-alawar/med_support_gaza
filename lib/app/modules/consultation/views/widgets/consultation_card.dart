import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/string_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';

import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

class ConsultationCard extends StatelessWidget {
  final ConsultationModel consultation;

  const ConsultationCard({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Doctor Initials
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: CustomText(
                      consultation.doctorInitials,
                      color: AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                16.horizontalSpace,
                // Doctor Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        consultation.doctorName,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      4.verticalSpace,
                      CustomText(
                        consultation.specialty,
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ],
                  ),
                ),
                // Status Badge


              ],
            ),
            16.verticalSpace,
            // Date and Time
            Row(
              children: [
                _buildInfoItem(
                  Icons.calendar_today_outlined,
                  consultation.date.toString(),
                ),
                24.horizontalSpace,
                _buildInfoItem(
                  Icons.access_time,
                  consultation.time,
                ),
                const Spacer(),
                // View Details Button

              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18.sp,
          color: Colors.grey[600],
        ),
        8.horizontalSpace,
        CustomText(
          text,
          fontSize: 14.sp,
          color: Colors.grey[600],
        ),
      ],
    );
  }
}