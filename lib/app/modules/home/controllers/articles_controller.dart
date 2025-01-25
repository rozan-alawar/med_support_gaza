import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/data/models/health_tip.dart';
import 'package:med_support_gaza/app/modules/home/views/widgets/health_tips.dart';

class HealthTipsController extends GetxController {
  final RxList<HealthTip> healthTips = <HealthTip>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHealthTips();
  }

  void loadHealthTips() {
    healthTips.value = [
      HealthTip(
        title: 'COVID-19_Prevention'.tr,
        description: 'COVID-19_Prevention_Description'.tr,
        icon: Icons.health_and_safety,
        backgroundColor: const Color(0xFFE8F5E9),
        iconColor: AppColors.primary,
      ),
      HealthTip(
        title: 'Mental_Health'.tr,
        description: 'Mental_Health_Description'.tr,
        icon: Icons.psychology,
        backgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
      ),
      HealthTip(
        title: 'Healthy_Diet'.tr,
        description: 'Healthy_Diet_Description'.tr,
        icon: Icons.restaurant_menu,
        backgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
    ];
  }
}