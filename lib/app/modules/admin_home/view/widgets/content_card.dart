import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/models/health_content_model.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_update_article_view.dart';
class ContentCard extends StatelessWidget {
  final HealthContentModel content;

  const ContentCard({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => UpdateArticleView(article: content)),
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Article Image
            ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: SizedBox(
                width: 86.w,
                height: 100.w,

                child: content.imageUrl != null
                    ? _buildArticleImage()
                    : _buildErrorPlaceholder(),
              ),
            ),
            12.width,
            // Article Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    content.title,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  8.height,
                  CustomText(
                    content.content,
                    fontSize: 12.sp,
                    color: AppColors.textLight,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    height: 1.3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleImage() {
    try {
      if (content.imageUrl!.startsWith('assets/')) {
        return Image.asset(
          content.imageUrl!,
          fit: BoxFit.fill,
          errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
        );
      }

      return Image.file(
        File(content.imageUrl!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildErrorPlaceholder(),
      );
    } catch (e) {
      return _buildErrorPlaceholder();
    }
  }

  Widget _buildErrorPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 24.sp,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}