import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class PatientMainView extends StatelessWidget {
  const PatientMainView({super.key});

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
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
20.height,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16),
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 4,
                        offset: const Offset(0, 2),
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.height,
                    CustomText(
                      'Upcoming Appointments'.tr,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                    16.height,
                    GestureDetector(
                      onTap: () { Get.toNamed(Routes.APPOINTMENT_BOOKING);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.add_circle_outline_sharp,
                              color: Colors.white,
                            ),
                            12.width,
                            CustomText(
                              'Schedule New Appointment'.tr,
                              fontSize: 12.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.height,
                    const AppoinmentInfoWidget(
                      time: '10:30 AM',
                      day: 'Today',
                      major: 'Cardiology',
                      doctorName: 'Dr. Ahmed Mohammed',
                    ),
                    8.height,
                    const AppoinmentInfoWidget(
                      time: '8:30 AM',
                      day: 'Today',
                      major: 'Cardiology',
                      doctorName: 'Dr. Ali Mohammed',
                    ),
                    8.height,  const AppoinmentInfoWidget(
                      time: '12:30 AM',
                      day: 'Tomorrow',
                      major: 'Cardiology',
                      doctorName: 'Dr. Samy Ahmed',
                    ),
                    8.height,
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

class AppoinmentInfoWidget extends StatelessWidget {
  const AppoinmentInfoWidget(
      {super.key,
      required this.doctorName,
      required this.major,
      required this.day,
      required this.time});
  final String doctorName;
  final String major;
  final String day;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
        const  Icon(
            Icons.access_time_rounded,
            color: AppColors.primary,
          ),
          16.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                doctorName.tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              // 2.height,
              CustomText(
                major.tr,
                fontSize: 11.sp,
                color: AppColors.textLight,
              ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                day.tr,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold, // color: A,
              ),
              CustomText(
                time.tr,
                fontSize: 11.sp,
                color: AppColors.textLight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
