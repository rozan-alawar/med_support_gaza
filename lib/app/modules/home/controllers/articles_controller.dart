import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/api_services/articles_api.dart';
import 'package:med_support_gaza/app/data/models/article_model.dart';
import 'package:med_support_gaza/app/data/models/health_tip.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class HealthTipsController extends GetxController {
  final RxList<HealthAwarenessTip> healthTips = <HealthAwarenessTip>[].obs;
  final RxList<Article> contentList = <Article>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadContent();
    loadHealthTips();
  }

  //------------------------ GET ARTICLES -----------------------------

  void loadContent() {
    ArticlesAPIService.getArticles(

      onSuccess: (response) {
        isLoading.value = false;
        final List<Article> articles = (response.data['articles'] as List)
            .map((articleJson) => Article.fromJson(articleJson))
            .toList();

        contentList.value =articles;
              isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  void loadHealthTips() {
    healthTips.value = [
      HealthAwarenessTip(
        title: 'COVID-19_Prevention'.tr,
        description: 'COVID-19_Prevention_Description'.tr,
        content: 'COVID-19_Content'.tr,
        bullets: 'COVID-19_Bullets'.tr,
        icon: Icons.medical_services,
        backgroundColor: const Color(0xFFE8F5E9),
        iconColor: AppColors.primary,
      ),
      HealthAwarenessTip(
        title: 'Mental_Health'.tr,
        description: 'Mental_Health_Description'.tr,
        content: 'Mental_Health_Content'.tr,
        bullets: 'Mental_Health_Bullets'.tr,
        icon: Icons.psychology,
        backgroundColor: const Color(0xFFE3F2FD),
        iconColor: const Color(0xFF1976D2),
      ),
      HealthAwarenessTip(
        title: 'Healthy_Diet'.tr,
        description: 'Healthy_Diet_Description'.tr,
        content: 'Healthy_Diet_Content'.tr,
        bullets: 'Healthy_Diet_Bullets'.tr,
        icon: Icons.restaurant_menu,
        backgroundColor: const Color(0xFFFFF3E0),
        iconColor: const Color(0xFFFF9800),
      ),
    ];
  }

  void openArticle(Article tip) {
    Get.toNamed(Routes.ARTICLE_TIP, arguments: {
      'article': json.encode(tip),
      'title': tip.title,
      'description': tip.content,
      'summary': tip.summary
    });
  }
}
