import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/home/controllers/home_controller.dart';
import 'package:med_support_gaza/app/modules/home/views/widgets/appointment_card.dart';
import 'package:med_support_gaza/app/modules/home/views/widgets/health_tips.dart';
import 'package:med_support_gaza/app/modules/home/views/widgets/suggested_doctors.dart';

class PatientMainView extends GetView<HomeController> {
  const PatientMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshData();
              },
              child: ListView(
                children: [
                  Obx(
                    () => CustomText(
                      'Hello, ${controller.userName.value}'.tr,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  20.height,
                  const AppointmentsCard(),
                  SizedBox(height: 20.h),
                  24.height,
                  const SuggestedDoctors(),
                  24.height,
               const   HealthTipsView(),
                  24.height,
                ],
              ),
            )),
      ),
    );
  }
}
