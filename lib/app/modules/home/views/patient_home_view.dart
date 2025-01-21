import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_assets.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/modules/consultation/controllers/consultation_controller.dart';
import 'package:med_support_gaza/app/modules/consultation/views/consultation_view.dart';
import 'package:med_support_gaza/app/modules/home/views/patient_main_view.dart';
import 'package:med_support_gaza/app/modules/profile/views/pages/patient_profile_view.dart';

import '../controllers/home_controller.dart';

class PatientHomeView extends GetView<HomeController> {
  const PatientHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ConsultationController());

    return Scaffold(
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: [
            const PatientMainView(),

            //  PatientProfileView(),
            ConsultationView(),

            const PatientProfileView(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          selectedItemColor: AppColors.accent,
          selectedLabelStyle:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
          onTap: (value) => controller.changeBottomNavIndex(value),
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.home,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.home,
              ),
              label: 'Home'.tr,
            ),
            // BottomNavigationBarItem(
            //   activeIcon: SvgPicture.asset(
            //     IconAssets.doctors,
            //     color: AppColors.accent,
            //   ),
            //   icon: SvgPicture.asset(
            //     IconAssets.doctors,
            //   ),
            //   label: 'Doctors'.tr,
            // ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.chatFill,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.chat,
              ),
              label: 'Chat'.tr,
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.personFill,
              ),
              icon: SvgPicture.asset(
                IconAssets.person,
              ),
              label: 'Profile'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
