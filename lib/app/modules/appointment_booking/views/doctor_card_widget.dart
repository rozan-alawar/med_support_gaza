import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
class DoctorCard extends StatelessWidget {
  final DoctorModel doctor;
  final bool isSelected;
  final VoidCallback onTap;

  const DoctorCard({
    super.key,
    required this.doctor,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: doctor.isApproved && doctor.isAvailable ? onTap : null,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                _buildDoctorImage(),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDoctorInfo(),
                      8.height,
                      _buildRatingAndExperience(),
                      if (!doctor.isApproved || !doctor.isAvailable)
                        _buildAvailabilityStatus(),
                    ],
                  ),
                ),
              ],
            ),
            12.height,
            _buildExpertise(),
            12.height,
            _buildLanguagesAndWorkingHours(),
          ],
        ),
      ),
    );
  }

  Widget _buildDoctorImage() {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: doctor.profileImage != null
              ? NetworkImage(doctor.profileImage!)
              : const AssetImage('assets/images/doctor.png') as ImageProvider,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          'Dr. ${doctor.fullName}',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        4.height,
        CustomText(
          doctor.speciality,
          fontSize: 14.sp,
          color: AppColors.textLight,
        ),
      ],
    );
  }

  Widget _buildRatingAndExperience() {
    return Row(
      children: [
        Icon(Icons.star_rounded, color: Colors.amber, size: 18.sp),
        4.width,
        CustomText(
          doctor.rating.toStringAsFixed(1),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        16.width,
        Icon(Icons.work_outline_rounded, color: AppColors.primary, size: 16.sp),
        4.width,
        CustomText(
          '${doctor.experience} ${'years'.tr}',
          fontSize: 14.sp,
          color: AppColors.textLight,
        ),
      ],
    );
  }

  Widget _buildAvailabilityStatus() {
    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: (doctor.isApproved ? Colors.orange : Colors.red).withOpacity(0.1),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: CustomText(
        !doctor.isApproved
            ? 'Pending Approval'.tr
            : !doctor.isAvailable
            ? 'Currently Unavailable'.tr
            : '',
        fontSize: 12.sp,
        color: doctor.isApproved ? Colors.orange : Colors.red,
      ),
    );
  }

  Widget _buildExpertise() {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: doctor.expertise.map((expertise) {
        return Container(
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
        );
      }).toList(),
    );
  }

  Widget _buildLanguagesAndWorkingHours() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Languages'.tr,
                fontSize: 12.sp,
                color: AppColors.textLight,
              ),
              4.height,
              CustomText(
                doctor.languages.join(', '),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ],
          ),
        ),
        if (doctor.isApproved && doctor.isAvailable)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.calendar_today,
                  color: isSelected ? Colors.white : AppColors.primary,
                  size: 16.sp,
                ),
                8.width,
                CustomText(
                  isSelected ? 'Selected'.tr : 'Book'.tr,
                  fontSize: 12.sp,
                  color: isSelected ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
      ],
    );
  }
}