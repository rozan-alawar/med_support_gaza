import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/article_model.dart';
import 'package:med_support_gaza/app/data/models/health_tip.dart';
import 'package:med_support_gaza/app/modules/home/controllers/articles_controller.dart';

class HealthTipsView extends GetView<HealthTipsController> {
  const HealthTipsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: CustomText(
            'Health_Awareness'.tr,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
        16.height,
        Obx(() => ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              itemCount: controller.contentList.length,
              separatorBuilder: (context, index) => 12.height,
              itemBuilder: (context, index) => _buildTipCard(
                controller.contentList[index],
              ),
            )),
      ],
    );
  }

  Widget _buildTipCard(Article tip) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.16),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        child: InkWell(
          onTap: () => controller.openArticle(tip),
          borderRadius: BorderRadius.circular(12.r),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w ,vertical: 12.h ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius:  BorderRadius.circular(12.r),
                  child: Image.network(
                    tip.image,
                    width: 70.w,
                    height: 80.h,
                    fit: BoxFit.cover,
                  ),
                ),
                16.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        tip.title,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 16.sp,
                        maxLines: 1,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                      8.height,
                      CustomText(
                        tip.content,
                  
                        fontSize: 14.sp,
                        color: AppColors.textLight,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      8.height,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
