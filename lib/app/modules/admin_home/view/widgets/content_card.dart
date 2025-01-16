import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_button_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_textfield_widget.dart';
import 'package:med_support_gaza/app/data/models/health_content_model.dart';


class ContentCard extends StatelessWidget {
  final HealthContentModel content;

  const ContentCard({Key? key, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w,vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (content.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
              child: Image.asset(
                content.imageUrl!,
                width: 90.w,
                height: 120.h,
                fit: BoxFit.contain,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        content.title,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      8.height,
                      CustomText(
                        content.content,
                        fontSize: 12.sp,
                        color: AppColors.textLight,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (content.tags.isNotEmpty) ...[
                        12.height,
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 8.h,
                          children: content.tags
                              .map((tag) => Chip(
                            label: CustomText(
                              tag,
                              fontSize: 12.sp,
                            ),
                            backgroundColor:
                            AppColors.primary.withOpacity(0.1),
                          ))
                              .toList(),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}