import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/widgets/custom_appiontment_card.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/doctor_appointment_management_controller.dart';

class DailyScheduleView extends GetView<DoctorAppointmentManagementController> {
  const DailyScheduleView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                'daily_schedule'.tr,
                fontFamily: 'LamaSans',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.dayilyAppointments.isEmpty) {
                    return CustomText(
                      'no_appointment_message'.tr,
                      fontFamily: 'LamaSans',
                      fontSize: 16.sp,
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.dayilyAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = controller.dayilyAppointments[index];
                      return CustomAppointmentCard(
                        patientName:
                            '${appointment.patient.firstName} ${appointment.patient.lastName}',
                        date: controller
                            .getFormatedDate(appointment.startTime.toDate()),
                        time: controller.fomatTime(appointment.startTime) ??
                            '00:00',
                        butText: 'cancel_appointment'.tr,
                        onPressed: () {
                          controller.cancelAppointment(index);
                        },
                      );
                    },
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
