import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/widgets/booking_card.dart';
import '../../../core/widgets/custom_text_widget.dart';
import '../controllers/doctor_appointment_management_controller.dart';

class DoctorBookingView extends GetView<DoctorAppointmentManagementController> {
  const DoctorBookingView({super.key});

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
                'Bookings'.tr,
                fontFamily: 'LamaSans',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
              Expanded(
                child: Obx(() {
                  if (controller.dayilyappointments.isEmpty) {
                    return CustomText(
                      'no_appointment_message'.tr,
                      fontFamily: 'LamaSans',
                      fontSize: 16.sp,
                    );
                  }
                  return ListView.builder(
                    itemCount: controller.appointments.length,
                    itemBuilder: (context, index) {
                      final appointment =
                          controller.appointments[index];
                      return BookingCard(
                        patientName:
                         //   appointment.period ?? 
                            'saja',
                        date: controller
                                .getFormatedDate(appointment.date)
,
                        time: appointment.startTime ,
                        onApprove: () {
                          controller.approveBooking(index);
                        },
                        onReject: () {
                          controller.rejectBooking(index);
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
