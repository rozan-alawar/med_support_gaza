import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/modules/home/controllers/articles_controller.dart';

class ArticleTipView extends GetView<HealthTipsController> {
  const ArticleTipView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          arguments['title'] ?? "",
          fontWeight: FontWeight.bold,
          fontSize: 16.sp,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            24.height,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomText(
                arguments['description'.tr] ?? '',
                fontSize: 14.sp,
                height: 1.6,
                color: AppColors.textLight,
                textAlign: TextAlign.justify,
              ),
            ),
            20.height,
            if (arguments['bullets'] != null) ...[
              CustomText(
                'Key_Points'.tr,
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
              16.height,
              ...((arguments['bullets'.tr] as String)
                  .split('|')
                  .map((bullet) => _buildBulletPoint(bullet.trim()))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Container(
              width: 6.w,
              height: 6.w,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
          ),
          12.width,
          Expanded(
            child: CustomText(
              text,
              fontSize: 14.sp,
              height: 1.6,
              color: AppColors.textLight,
              textAlign: TextAlign.justify,
            ),
          ),
        ],
      ),
    );
  }
}
