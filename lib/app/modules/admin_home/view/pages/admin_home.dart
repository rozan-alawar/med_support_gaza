import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_assets.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_doctors.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_insights.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_profile.dart';

import '../../controller/admin_home_controller.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminHomeController controller = Get.put(AdminHomeController());

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications,
              color: AppColors.accent,
            ),
            onPressed: () {
              controller.getPatientsCount();
            },
          )
        ],
      ),
      body: Obx(() {
        // Display the corresponding page
        switch (controller.selectedIndex.value) {
          case 0:
            return const InsightsPage();
          case 1:
            return const AdminProfile();
          case 2:
            return  Container();

          case 3:
            return const AdminDoctors();
          default:
            return const SizedBox();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          backgroundColor: AppColors.white,
          selectedItemColor: AppColors.accent,
          currentIndex: controller.selectedIndex.value,
          onTap: (index) {
            controller.changeTab(index);
          },
          items: [
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.dashboard,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.dashboard,

              ),
              label: 'Dashboard'.tr,
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.userManagment,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.userManagment,
              ),
              label: 'userManagment'.tr,
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.contentManagment,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.contentManagment,
              ),
              label: 'contentManagment'.tr,
            ),
            BottomNavigationBarItem(
              activeIcon: SvgPicture.asset(
                IconAssets.serviceManagment,
                color: AppColors.accent,
              ),
              icon: SvgPicture.asset(
                IconAssets.serviceManagment,
              ),
              label: 'serviceManagment'.tr,
            ),
          ],
        ),
      ),
    );
  }
}
