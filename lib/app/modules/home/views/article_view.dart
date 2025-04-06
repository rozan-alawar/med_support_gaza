import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/article_model.dart';
import 'package:med_support_gaza/app/modules/home/controllers/articles_controller.dart';

class ArticleTipView extends GetView<HealthTipsController> {
  const ArticleTipView({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments as Map<String, String>;
    Article tip = Article.fromJson(json.decode(arguments['article'] ?? ""));
    List<String> title =        arguments['title']!=null?
    arguments['title']!.split(" "):[];
    String x="";
    for(int i =0; i<title.length&& i<3; i++)
      x= x+ " "+ title[i];
    return Scaffold(
appBar: AppBar(
  centerTitle: true,
  title:   CustomText(
   x,
    fontWeight: FontWeight.bold,
    maxLines: 3,
    fontSize: 16.sp,
  ),
),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          children: [
20.height,
            ClipRRect(
              child: Image.network(tip.image,fit: BoxFit.cover,height: 200.h,width: double.infinity,),
              borderRadius: BorderRadius.circular(16.r),
            ),
            30.height,
            CustomText(
              arguments['title'] ?? "",
              fontWeight: FontWeight.bold,
              maxLines: 3,
              fontSize: 16.sp,
            ),
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  24.height,
                  CustomText(
                    arguments['description'.tr] ?? '',
                    fontSize: 14.sp,
                    height: 1.6,
                    maxLines: 800,
                    color: AppColors.textLight,
                    textAlign: TextAlign.justify,
                  ),
                  10.height,
                  CustomText(
                    arguments['summary'.tr] ?? '',
                    fontSize: 14.sp,
                    height: 1.6,
                    color: AppColors.textLight,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
