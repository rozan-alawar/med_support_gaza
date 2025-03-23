// insights_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_content_controller.dart';

import '../../../../core/widgets/custom_text_widget.dart';
import '../../controller/admin_home_controller.dart';
import '../widgets/insight_container.dart';

class InsightsPage extends StatelessWidget {
  const InsightsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminHomeController controller = Get.find<AdminHomeController>();
    final ContentController articlesController = Get.find<ContentController>();

    return RefreshIndicator(
      onRefresh: () async{
        controller.getDoctors();
        controller.getPatients();
        articlesController.loadContent();
      },
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomText('Show Insights', fontSize: 20),
            16.height,
            InsightContainer(
              mainText: 'Number of Patients',
              subTextWidget: Obx(
                () => CustomText(
                  '(${controller.patientsCount.value})',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            16.height,
            Obx(
              () => InsightContainer(
                mainText: 'Number of Doctors',
                subTextWidget: CustomText(
                  '${controller.doctorsCount.value}',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),
            ),
            16.height,
             InsightContainer(
              mainText: 'Number of published articles',
              subTextWidget: CustomText(
                '(${articlesController.articlesCount}) article have been published so far',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
