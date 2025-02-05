// lib/app/modules/consultation/widgets/active_consultation_card.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/consultation_model.dart';

class ActiveConsultationCard extends StatelessWidget {
  final ConsultationModel consultation;
  final VoidCallback onStartChat;

  const ActiveConsultationCard({
    Key? key,
    required this.consultation,
    required this.onStartChat,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLiveIndicator(),
          _buildDoctorInfo(),
          _buildTimeInfo(),
          _buildActionButton(),
        ],
      ),
    );
  }

  Widget _buildLiveIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12.r),
          topRight: Radius.circular(12.r),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8.w,
            height: 8.w,
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
          ),
          8.width,
          CustomText(
            'Active Now',
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: AppColors.primary.withOpacity(0.2),
            child: Text(
              consultation.doctorName.substring(0, 2).toUpperCase(),
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
              ),
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  consultation.doctorName,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
                4.height,
                CustomText(
                  consultation.specialty,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 16.sp,
            color: Colors.grey[600],
          ),
          8.width,
          CustomText(
            'Today',
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
          24.width,
          Icon(
            Icons.access_time,
            size: 16.sp,
            color: Colors.grey[600],
          ),
          8.width,
          CustomText(
            consultation.time,
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onStartChat,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 12.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.chat_bubble_outline, size: 20.sp),
              8.width,
              Text(
                'Start Chat',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}