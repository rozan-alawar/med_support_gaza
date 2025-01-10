import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
        backgroundColor: Colors.transparent,
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
            return const AdminDoctors();
          case 2:
            return const AdminProfile();
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
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.insights),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.medical_services),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
