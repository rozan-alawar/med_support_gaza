import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_assets.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/cached_image.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/modules/home/controllers/patient_doctors_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class PatientDoctorsView extends GetView<PatientDoctorsController> {
  const PatientDoctorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          'AvailableDoctors'.tr,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(child: _buildDoctorsList()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: CustomTextField(
        hintText: 'SearchDoctors'.tr,
        controller: controller.searchController,
        onChanged: controller.onSearchChanged,
        prefixIcon: Icons.search,
        keyboardType: TextInputType.text,
      ),
    );
  }

  Widget _buildDoctorsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return RefreshIndicator(
        onRefresh: controller.refreshDoctors,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: controller.doctors.length,
          itemBuilder: (context, index) {
            final doctor = controller.doctors[index];
            print(doctor.email);
            return _buildDoctorCard(doctor);
          },
        ),
      );
    });
  }

  Widget _buildDoctorCard(Doctor doctor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.toNamed(Routes.DOCTOR_DETAILS, arguments: doctor);
            print(doctor.phoneNumber);
          },
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                _buildDoctorAvatar(doctor),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomText(
                                  '${doctor.firstName} ${doctor.lastName}',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                4.height,
                                CustomText(
                                  doctor.major.toString(),
                                  fontSize: 14.sp,
                                  color: Colors.grey[600],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      12.height,
                      Row(
                        children: [
                          _buildInfoChip(
                            icon: Icons.location_on_outlined,
                            label: doctor.country.toString(),
                            color: AppColors.primary,
                          ),
                          8.width,
                          _buildInfoChip(
                              icon: Icons.star_rate_rounded,
                              label: doctor.averageRating.toString(),
                              color: AppColors.primary,
                              iconColor: Colors.yellow,size: 20.h),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorAvatar(Doctor doctor) {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50.r),
        child: doctor.image != null
            ? ImageWithAnimatedShader(imageUrl: doctor.image.toString())
            : Icon(Icons.person, size: 50.r, color: AppColors.gray),
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    return Container(
      color: AppColors.primary.withOpacity(0.1),
      child: Icon(
        Icons.person,
        size: 40.r,
        color: AppColors.primary,
      ),
    );
  }

  Widget _buildInfoChip(
      {required IconData icon,
      required String label,
      required Color color,
      Color? iconColor,double? size}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: size??16.r, color: iconColor ?? color),
          4.width,
          CustomText(
            label,
            fontSize: 12.sp,
            color: color,
          ),
        ],
      ),
    );
  }
}
