import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';

import '../../../../core/widgets/custom_text_widget.dart';
import '../../controller/admin_home_controller.dart';
import '../widgets/insight_container.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminHomeController controller = Get.put(AdminHomeController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: AppColors.accent,
              size: 24.sp,
            ),
            onPressed: () {
              controller.getPatientsCount();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 20.w,
          vertical: 20.h,
        ),
        child: Column(
          spacing: 16.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText('Show Insights', fontSize: 20),
            InsightContainer(
              mainText: 'Number of active users (Patients)',
              subTextWidget: Obx(
                () => CustomText(
                  '(${controller.patientsCount.value}) user active now',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            InsightContainer(
              mainText: 'Number of active users (Doctors)',
              subTextWidget: Obx(
                () => const CustomText(
                  '(0) user active now',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            InsightContainer(
              mainText: 'Number of active published articles',
              subTextWidget: Obx(
                () => const CustomText(
                  '(0) artivle have been published so far',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
