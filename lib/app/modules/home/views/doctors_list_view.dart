import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/modules/home/controllers/patient_doctors_controller.dart';


class PatientDoctorsView extends GetView<PatientDoctorsController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        centerTitle: true,
        title: CustomText(
          'AvailableDoctors'.tr,
          fontSize: 16.sp,
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
            offset: Offset(0, 2),
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
            return _buildDoctorCard(doctor);
          },
        ),
      );
    });
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
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
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Get.toNamed('/doctor-details', arguments: doctor),
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
                                  doctor.fullName,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                                4.height,
                                CustomText(
                                  doctor.speciality,
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
                            Icons.star,
                            '${doctor.rating}',
                            Colors.amber,
                          ),
                          12.width,
                          _buildInfoChip(
                            Icons.work_outline,
                            '${doctor.experience} ${'Years'.tr}'
                                ,
                            AppColors.primary,
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
      ),
    );
  }

  Widget _buildDoctorAvatar(DoctorModel doctor) {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(35.r),
        child: doctor.profileImage != null
            ? Image.network(
          doctor.profileImage!,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildAvatarPlaceholder(),
        )
            : _buildAvatarPlaceholder(),
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

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.r, color: color),
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