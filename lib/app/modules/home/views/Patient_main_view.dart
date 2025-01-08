import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/string_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/home/controllers/home_controller.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
class PatientMainView extends GetView<HomeController> {
  const PatientMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          child: Obx(() => RefreshIndicator(
            onRefresh: () async {
              await controller.refreshData();
            },
            child: ListView(
              children: [
                Obx(() =>  CustomText(
                  'Hello, ${controller.userName.value}'.tr,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
          ),
                ),
                20.height,
                _buildAppointmentsCard(context),
                SizedBox(height: 20.h),

              ],
            ),
          )),
        ),
      ),
    );
  }

  Widget _buildAppointmentsCard(BuildContext context) {
    return Container(
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
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          10.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'Upcoming Appointments'.tr,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
              if (controller.isLoading.value)
                SizedBox(
                  width: 20.w,
                  height: 20.h,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
            ],
          ),
          16.height,
          _buildScheduleButton(),
          16.height,
          Obx(() =>  _buildAppointmentsList(),
      ),

        ],
      ),
    );
  }

  Widget _buildScheduleButton() {
    return InkWell(
      onTap: () => Get.toNamed(Routes.APPOINTMENT_BOOKING),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
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
    );
  }

  Widget _buildAppointmentsList() {
    if (controller.isLoading.value && controller.appointments.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      );
    }

    if (controller.appointments.isEmpty) {
      return _buildEmptyState();
    }

    return   ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: controller.appointments.length,
      separatorBuilder: (context, index) => 10.height,
      itemBuilder: (context, index) {
        final appointment = controller.appointments[index];
        return AppoinmentInfoWidget(
          time: appointment.time,
          day: appointment.date.toString().formatAppointmentDay(appointment.date),
          major: appointment.specialization,
          doctorName: appointment.doctorName,
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 48.sp,
            color: AppColors.textLight,
          ),
          16.height,
          CustomText(
            'No Upcoming Appointments'.tr,
            fontSize: 14.sp,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
          8.height,
          CustomText(
            'Schedule an appointment to get started'.tr,
            fontSize: 12.sp,
            color: AppColors.textLight.withOpacity(0.7),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class AppoinmentInfoWidget extends StatelessWidget {
  const AppoinmentInfoWidget({
    super.key,
    required this.doctorName,
    required this.major,
    required this.day,
    required this.time,
  });

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
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.access_time_rounded,
              color: AppColors.primary,
              size: 20.sp,
            ),
          ),
          16.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  doctorName,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                ),
                CustomText(
                  major,
                  fontSize: 11.sp,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CustomText(
                day,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              CustomText(
                time,
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