import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_assets.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/modules/consultation/controllers/consultation_controller.dart';
import 'package:med_support_gaza/app/modules/consultation/views/pages/consultation_view.dart';
import 'package:med_support_gaza/app/modules/home/views/patient_main_view.dart';
import 'package:med_support_gaza/app/modules/profile/views/pages/patient_profile_view.dart';

import '../controllers/home_controller.dart';
class PatientHomeView extends GetView<HomeController> {
  const PatientHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(ConsultationController());

    return Scaffold(
      body: Obx(
            () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: IndexedStack(
            key: ValueKey<int>(controller.currentIndex.value),
            index: controller.currentIndex.value,
            children: const [
              PatientMainView(),
              ConsultationView(),
              PatientProfileView(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
            () => BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          selectedItemColor: AppColors.accent,
          unselectedItemColor: Colors.grey,
          backgroundColor: Colors.white,
          elevation: 8,
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12.sp
          ),
          unselectedLabelStyle: TextStyle(
              fontSize: 12.sp
          ),
          type: BottomNavigationBarType.fixed,
          onTap: (value) => controller.changeBottomNavIndex(value),
          items: [
            _buildNavItem(
              icon: IconAssets.home,
              activeIcon: IconAssets.home,
              label: 'Home'.tr,
            ),
            _buildNavItem(
              icon: IconAssets.chat,
              activeIcon: IconAssets.chatFill,
              label: 'Consultations'.tr,
              // badge: controller.hasActiveConsultation,
            ),
            _buildNavItem(
              icon: IconAssets.person,
              activeIcon: IconAssets.personFill,
              label: 'Profile'.tr,
            ),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required String icon,
    required String activeIcon,
    required String label,
    bool badge = false,
  }) {
    return BottomNavigationBarItem(
      icon: Stack(
        children: [
          SvgPicture.asset(
            icon,
            color: Colors.grey,
          ),
          if (badge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      activeIcon: Stack(
        children: [
          SvgPicture.asset(
            activeIcon,
            color: AppColors.accent,
          ),
          if (badge)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}