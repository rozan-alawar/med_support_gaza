import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class DoctorDetailsView extends StatelessWidget {
  final DoctorModel doctor = Get.arguments;

   DoctorDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          'DoctorProfile'.tr,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16.w),
        child: CustomButton(
          text: 'BookAppointment'.tr,
          color: AppColors.primary,
          onPressed: () =>Get.toNamed(
            Routes.APPOINTMENT_BOOKING,
            arguments: {'doctor': doctor},
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDoctorHeader(),
            16.height,
            _buildInfoSection(),
            16.height,
            _buildAboutSection(),
            16.height,
            _buildExpertiseSection(),
            16.height,
            _buildLanguagesSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorHeader() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 100.w,
            height: 100.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.r),
              child: doctor.profileImage != null
                  ? Image.network(doctor.profileImage!, fit: BoxFit.cover)
                  : Icon(Icons.person, size: 50.r, color: AppColors.primary),
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  doctor.fullName,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
                8.height,
                CustomText(
                  doctor.speciality,
                  fontSize: 14.sp,
                  color: Colors.grey[600],
                ),
                8.height,
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.r),
                    4.width,
                    CustomText(
                      '${doctor.rating}',
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                    ),
                    16.width,
                    Icon(Icons.work_outline, color: AppColors.primary, size: 16.r),
                    4.width,
                    CustomText(
                      '${doctor.experience} ${'Years'.tr}',
                      fontSize: 14.sp,
                      color: Colors.grey[800],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(
            Icons.phone_outlined,
            'Phone'.tr,
            doctor.phoneNo,
          ),
          _buildInfoItem(
            Icons.location_on_outlined,
            'Location'.tr,
            doctor.country,
          ),

        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String value, {Color? iconColor}) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.primary, size: 24.r),
        8.height,
        CustomText(
          title,
          fontSize: 12.sp,
          color: Colors.grey[600],
        ),
        4.height,
        CustomText(
          value,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal:  24.w,vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'About'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          12.height,
          CustomText(
            doctor.about,
            fontSize: 14.sp,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildExpertiseSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal:  24.w,vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Expertise'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          12.height,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: doctor.expertise.map((expertise) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: CustomText(
                expertise,
                fontSize: 12.sp,
                color: AppColors.primary,
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal:  24.w,vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            'Languages'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
          12.height,
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: doctor.languages.map((language) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.language, size: 16.r, color: Colors.blue),
                  4.width,
                  CustomText(
                    language,
                    fontSize: 12.sp,
                    color: Colors.blue,
                  ),
                ],
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}