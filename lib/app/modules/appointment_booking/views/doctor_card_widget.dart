import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/cached_image.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_booking_controller.dart';
class DoctorCard extends GetView<AppointmentBookingController> {
  final Doctor doctor;
  RxBool? isSelected = false.obs;
  final VoidCallback onTap;

   DoctorCard({
    super.key,
    required this.doctor,
    this.isSelected,

    required this.onTap,
  });

  @override

  Widget build(BuildContext context) {
     this.isSelected= (controller.selectedDoctor?.value.id == doctor.id).obs;
    return Obx(() =>  GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: controller.selectedDoctor?.value.id == doctor.id ? AppColors.primary : Colors.grey[200]!,
              width: isSelected!.value ? 2 : 1,
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
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50.r),
                    child: doctor.image != null
                        ? ImageWithAnimatedShader(imageUrl: doctor.image.toString(),width: 80.w,height: 90.h,)
                        : Icon(Icons.person, size: 70.r, color: AppColors.gray),
                  ),                  16.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDoctorInfo(),
                        8.height,
                        _buildRatingAndExperience(),

                          // _buildAvailabilityStatus(),
                      ],
                    ),
                  ),
                ],
              ),
              12.height,
              // _buildExpertise(),
              12.height,
              _buildLanguagesAndWorkingHours(),
            ],
          ),
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
          image: doctor.image != null
              ? NetworkImage(doctor.image!)
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
          'Dr. ${doctor.firstName} ${doctor.lastName}',
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
        4.height,
        CustomText(
          doctor.major.toString(),
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
          doctor.averageRating.toString(),
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        16.width,
        Icon(Icons.work_outline_rounded, color: AppColors.primary, size: 16.sp),
        4.width,
        // CustomText(
        //   '${doctor.experience} ${'years'.tr}',
        //   fontSize: 14.sp,
        //   color: AppColors.textLight,
        // ),
      ],
    );
  }

  // Widget _buildAvailabilityStatus() {
  //   return Container(
  //     margin: EdgeInsets.only(top: 8.h),
  //     padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
  //     decoration: BoxDecoration(
  //       color: (doctor.isApproved ? Colors.orange : Colors.red).withOpacity(0.1),
  //       borderRadius: BorderRadius.circular(4.r),
  //     ),
  //     child: CustomText(
  //       !doctor.isApproved
  //           ? 'Pending Approval'.tr
  //           : !doctor.isAvailable
  //           ? 'Currently Unavailable'.tr
  //           : '',
  //       fontSize: 12.sp,
  //       color: doctor.isApproved ? Colors.orange : Colors.red,
  //     ),
  //   );
  // }
  //
  // Widget _buildExpertise() {
  //   return Wrap(
  //     spacing: 8.w,
  //     runSpacing: 8.h,
  //     children: doctor.expertise.map((expertise) {
  //       return Container(
  //         padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
  //         decoration: BoxDecoration(
  //           color: AppColors.primary.withOpacity(0.1),
  //           borderRadius: BorderRadius.circular(20.r),
  //         ),
  //         child: CustomText(
  //           expertise,
  //           fontSize: 12.sp,
  //           color: AppColors.primary,
  //         ),
  //       );
  //     }).toList(),
  //   );
  // }

  Widget _buildLanguagesAndWorkingHours() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Languages: '.tr,
                fontSize: 12.sp,
                color: AppColors.textLight,
              ),
              4.height,
              CustomText(
                'arabic'.tr,
                fontSize: 12.sp,
              ),

            ],
          ),
        ),
        // if (doctor.isApproved && doctor.isAvailable)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: isSelected!.value
                  ? AppColors.primary
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected!.value ? Icons.check_circle : Icons.calendar_today,
                  color: isSelected!.value ? Colors.white : AppColors.primary,
                  size: 16.sp,
                ),
                8.width,
                CustomText(
                  isSelected!.value ? 'Selected'.tr : 'Book'.tr,
                  fontSize: 12.sp,
                  color: isSelected!.value ? Colors.white : AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
      ],
    );
  }
}