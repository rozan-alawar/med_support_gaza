import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';

import '../../controller/admin_user_management_controller.dart';

class AdminUserManagementView extends GetView<AdminUserManagementController> {
  const AdminUserManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(
      () => AdminUserManagementController(),
    );
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              _buildSearchBar(),
              _buildTabs(),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildPatientsList(),
                    _buildDoctorsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: EdgeInsets.all(16.w),
      color: Colors.white,
      // child:  Padding(
      // padding: EdgeInsets.all(16.w),
      // child: CustomTextField(
      //   hintText: 'search'.tr,
      //   onChanged: controller.onSearchChanged,
      //   prefixIcon: Icons.search,
      //
      // ),
      // ),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: 'search'.tr,
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 12.h,
          ),
        ),
        onChanged: controller.onSearchChanged,
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      color: Colors.white,
      child: TabBar(
        indicatorColor: AppColors.primary,
        labelColor: AppColors.primary,
        unselectedLabelColor: Colors.grey,
        tabs: [
          Tab(text: 'patients'.tr),
          Tab(text: 'doctors'.tr),
        ],
      ),
    );
  }

  Widget _buildPatientsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final patients = controller.filteredPatients;
      if (patients.isEmpty) {
        return Center(child: Text('no_patients_found'.tr));
      }

      return RefreshIndicator(
        onRefresh: controller.refreshUsers,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: patients.length,
          itemBuilder: (context, index) => _buildPatientCard(patients[index]),
        ),
      );
    });
  }

  Widget _buildDoctorsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final doctors = controller.filteredDoctors;
      if (doctors.isEmpty) {
        return Center(child: Text('no_doctors_found'.tr));
      }

      return RefreshIndicator(
        onRefresh: controller.refreshUsers,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          itemCount: doctors.length,
          itemBuilder: (context, index) => _buildDoctorCard(doctors[index]),
        ),
      );
    });
  }

  Widget _buildPatientCard(PatientModel patient) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25.r,
            child: Text(
              patient.firstName[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  '${patient.firstName} ${patient.lastName}',
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                4.height,
                CustomText(
                  patient.email,
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                4.height,
                Row(
                  children: [
                    Icon(Icons.phone, size: 14.sp, color: Colors.grey),
                    4.width,
                    CustomText(
                      patient.phoneNumber,
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => controller.deleteUser(patient.id.toString(), false),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorCard(DoctorModel doctor) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              if (doctor.profileImage != null)
                CircleAvatar(
                  radius: 25.r,
                  backgroundImage: NetworkImage(doctor.profileImage!),
                )
              else
                CircleAvatar(
                  radius: 25.r,
                  child: Text(
                    doctor.firstName[0].toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              16.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      '${doctor.firstName} ${doctor.lastName}',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    8.height,
                    CustomText(
                      doctor.email,
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ),
            ],
          ),
          30.height,
          Row(
            children: [
              Expanded(
                  child: CustomButton(
                      height: 35.h,
                      fontSize: 11.sp,
                      text: 'delete_user'.tr,
                      color: Colors.red,
                      onPressed: () => controller.deleteUser(doctor.id, true))),
              20.width,
              Expanded(
                  child: CustomButton(
                      text: 'send_email'.tr,
                      fontSize: 11.sp,
                      height: 35.h,
                      color: AppColors.primary,
                      onPressed: () =>
                          controller.sendEmailToDoctor(doctor.id))),
            ],
          ),
        ],
      ),
    );
  }
}
