import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../appointment_booking/controllers/doctor_appointment_management_controller.dart';
import '../../appointment_booking/views/doctor_appointment_management_view.dart';
import '../controllers/doctor_home_controller.dart';

class DocotrHomeView extends GetView<DoctorHomeController> {
  DocotrHomeView({super.key});
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(

        body: Obx(
          () => Align(
            //  alignment: ,
            child: IndexedStack(
              alignment: Alignment.topRight,
              index: controller.currentIndex.value,
              children: [
                Center(),
                Center(),
                DoctorAppointmentManagementView(),
                Center(),
              ],
            ),
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
                  IconAssets.home1,
                  color: AppColors.accent,
                ),
                icon: SvgPicture.asset(
                  IconAssets.home,
                ),
                label: 'Home'.tr,
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
                  IconAssets.time_management2,
                  //color: AppColors.accent,
                ),
                icon: SvgPicture.asset(
                  IconAssets.time_management,
                ),
                label: 'time_management'.tr,
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
      ),
    );
  }
}
