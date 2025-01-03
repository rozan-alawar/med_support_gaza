import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

class PatientMainView extends StatelessWidget {
  const PatientMainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'Hello, User Name'.tr,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 20.h),

              GestureDetector(
                onTap: () {
                  print('New Consultation');
                },
                child: Container(
                  padding: EdgeInsets.all(15.w),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: CustomText(
                      'NewConsultation'.tr,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Upcoming Appointments
              CustomText(
                'UpcomingAppointments'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.all(15.w),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      'Dr. Ahmed Mohammed'.tr,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    SizedBox(height: 5.h),
                    CustomText(
                      'Today - 10:30 AM'.tr,
                      fontSize: 12.sp,
                      color: AppColors.textLight,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.h),

              // Medical Records
              CustomText(
                'MedicalRecords'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
