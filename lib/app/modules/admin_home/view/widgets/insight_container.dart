import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_text_widget.dart';

class InsightContainer extends StatelessWidget {
  final String mainText;
  final Widget subTextWidget;
  const InsightContainer({
    super.key,
    required this.mainText,
    required this.subTextWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 150.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.gray,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          // spacing: 16.h,
          children: [
            CustomText(
              mainText,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
            subTextWidget,
          ],
        ),
      ),
    );
  }
}
