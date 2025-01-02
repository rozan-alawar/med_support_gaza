import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_assets.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/modules/home/views/Patient_main_view.dart';

import '../controllers/home_controller.dart';

class PatientHomeView extends GetView<HomeController> {
  PatientHomeView({super.key});
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PatientMainView(),

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
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.doctors,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.doctors,
              ),
              label: 'Doctors'.tr,
            ),
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
