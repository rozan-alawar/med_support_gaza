import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/appointment_card.dart';
import '../../../core/widgets/quick_stats_card.dart';
import '../../../routes/app_pages.dart';
import '../../appointment_booking/controllers/doctor_appointment_management_controller.dart';
import '../../consultation/controllers/doctor_consultation_controller.dart';
import '../controllers/doctor_home_controller.dart';

class DoctorMainView extends GetView<DoctorHomeController> {
  const DoctorMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              45.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'daily_schedule'.tr,
                    fontFamily: 'LamaSans',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.DOCTOR_DAILY_SCHEDULE);
                    },
                    child: CustomText(
                      'more'.tr,
                      fontFamily: 'LamaSans',
                      fontSize: 12.sp,
                      color: AppColors.textLight,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 190.h,
                child: Obx(() {
                  final dayilyAppointments =
                      Get.find<DoctorAppointmentManagementController>()
                          .dayilyAppointments;
                  if (dayilyAppointments.isEmpty) {
                    return Center(child: Text('no_appointment_message'.tr));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: dayilyAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = dayilyAppointments[index];
                      return AppointmentCard(
                        patientName:
                            '${appointment.patient.firstName} ${appointment.patient.lastName}' ??
                                'unknown patient',
                        date: Get.find<DoctorAppointmentManagementController>()
                            .getFormatedDate(appointment.startTime.toDate()),
                        time: Get.find<DoctorAppointmentManagementController>()
                                .fomatTime(appointment.startTime) ??
                            '00:00',
                      );
                    },
                  );
                }),
              ),
              20.height,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    'Bookings'.tr,
                    fontFamily: 'LamaSans',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.DOCTOR_BOOKING_MANAGEMENT);
                    },
                    child: CustomText(
                      'more'.tr,
                      fontFamily: 'LamaSans',
                      fontSize: 12.sp,
                      color: AppColors.textLight,
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 190.h,
                child: Obx(() {
                  final pandingAppointments =
                      Get.find<DoctorAppointmentManagementController>()
                          .PandingAppointments;
                  if (pandingAppointments.isEmpty) {
                    return Center(child: Text('no_appointment_message'.tr));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: pandingAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = pandingAppointments[index];
                      return AppointmentCard(
                        patientName:
                            '${appointment.patient.firstName} ${appointment.patient.lastName}',
                        date: Get.find<DoctorAppointmentManagementController>()
                            .getFormatedDate(appointment.startTime.toDate()),
                        time: Get.find<DoctorAppointmentManagementController>()
                                .fomatTime(appointment.startTime) ??
                            '00:00',
                      );
                    },
                  );
                }),
              ),
              20.height,
              CustomText(
                'quick_statistics'.tr,
                fontFamily: 'LamaSans',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              10.height,
              QuickStatsCard(
                unreadMessages: Get.find<DoctorConsultationController>()
                    .totalUnreadMessages
                    .value,
              ),
            ])),
      )),
    );
  }
}
