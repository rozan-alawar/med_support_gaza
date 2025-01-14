import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/doctor_profile_controller.dart';
import 'package:med_support_gaza/app/modules/profile/views/doctor_profile_view.dart';

import '../../../core/utils/app_assets.dart';
import '../../../core/utils/app_colors.dart';
import '../../appointment_booking/controllers/doctor_appointment_management_controller.dart';
import '../../appointment_booking/views/doctor_appointment_management_view.dart';
import '../controllers/doctor_home_controller.dart';
import 'doctor_main_view.dart';

class DocotrHomeView extends GetView<DoctorHomeController> {
  DocotrHomeView({super.key});
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>DoctorProfileController());
    return SafeArea(
      child: Scaffold(
         appBar: AppBar(
            actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                IconAssets.bell,
              ),
            )
          ],
         ),
        body: Obx(
          () => Align(
            child: IndexedStack(
              alignment: Alignment.topRight,
              index: controller.currentIndex.value,
              children: [
                DoctorMainView(),
                Center(),
                DoctorAppointmentManagementView(),
                DoctorProfileView(),
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
                  IconAssets.home1,
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
