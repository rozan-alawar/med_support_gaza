import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/modules/home/controllers/patient_doctors_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
class SuggestedDoctors extends GetView<PatientDoctorsController> {
  const SuggestedDoctors({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'TopDoctors'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              TextButton(
                onPressed: () => Get.toNamed(Routes.DOCTORS_LIST),
                child: CustomText(
                  'ViewAll'.tr,
                  color: AppColors.primary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        12.height,
        SizedBox(
          height: 225.h,
          child: Obx(() => ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: controller.topDoctors.length,
            itemBuilder: (context, index) {
              final doctor = controller.topDoctors[index];
              return _buildDoctorCard(doctor);
            },
          )),
        ),
      ],
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 16.w, bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed(Routes.DOCTOR_DETAILS, arguments: doctor),
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            children: [
              Container(
                height: 100.h,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                ),
                child: Center(
                  child: doctor.profileImage != null
                      ? CircleAvatar(
                    radius: 32.r,
                    backgroundImage: NetworkImage(doctor.profileImage!),
                  )
                      : CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person_outline,
                        color: AppColors.primary, size: 32.r),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(12.w),
                child: Column(
                  children: [
                    CustomText(
                      doctor.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    4.height,
                    CustomText(
                      doctor.speciality,
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                    8.height,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16.sp),
                        4.width,
                        CustomText(
                          doctor.rating.toString(),
                          fontSize: 12.sp,
                          color: Colors.grey[600],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}