import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/extentions/string_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/home/controllers/home_controller.dart';
import 'package:med_support_gaza/app/modules/home/views/widgets/appointment_card.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class PatientMainView extends GetView<HomeController> {
  const PatientMainView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
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
                  AppointmentsCard(),
                  SizedBox(height: 20.h),
                  24.height,
                  _buildSuggestedDoctors(),
                  24.height,
                  _buildHealthArticles(),
                ],
              ),
            )),
      ),
    );
  }


  Widget _buildSuggestedDoctors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                'Top Doctors'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              TextButton(
                onPressed: () {},
                child: CustomText(
                  'View All'.tr,
                  color: AppColors.primary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
        12.height,
        SizedBox(
          height: 225.h,
          child: ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) => _buildDoctorCard(),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorCard() {
    return Container(
      width: 160.w,
      margin: EdgeInsets.only(right: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 100.h,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Center(
              child: CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.white,
                child: Icon(Icons.person_outline,
                    color: AppColors.primary, size: 32.r),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              children: [
                CustomText(
                  'Dr. Amin Amin'.tr,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
                4.height,
                CustomText(
                  'Pediatrician'.tr,
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
                8.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16.sp),
                    4.width,
                    CustomText(
                      '4.9',
                      fontSize: 12.sp,
                      color: Colors.grey[600],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthArticles() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: CustomText(
            'Health Tips'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        12.height,
        GridView.builder(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16.h,
            crossAxisSpacing: 16.w,
            childAspectRatio: 1.2,
          ),
          itemCount: 4,
          itemBuilder: (context, index) => _buildHealthTipCard(),
        ),
      ],
    );
  }

  Widget _buildHealthTipCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12.r),
        image: DecorationImage(
          image: AssetImage('assets/images/health_tip_bg.png'),
          fit: BoxFit.cover,
          opacity: 0.2,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.health_and_safety_outlined,
                    color: Colors.white, size: 24.sp),
                Spacer(),
                CustomText(
                  'Flu Prevention Tips'.tr,
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
