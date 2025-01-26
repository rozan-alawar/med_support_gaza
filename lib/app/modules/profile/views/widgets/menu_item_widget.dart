import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_support_gaza/app/core/extentions/space_extention.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

class MenuItemWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  final bool hasDropdown;
  final bool isLogout;

  const MenuItemWidget(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      this.hasDropdown = false,
      this.isLogout = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.grey[200]!,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isLogout ? Colors.red : AppColors.primary,
              size: 24.sp,
            ),
            12.width,
            Expanded(
              child: CustomText(
                title,
                fontSize: 16.sp,
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
            if (hasDropdown)
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey,
                size: 18.sp,
              ),
          ],
        ),
      ),
    );
  }
}
