import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.text,
      required this.color,
      required this.onPressed,
      this.width = 90,
      this.height = 40,
      this.fontSize = 16,
      this.borderColor,
      this.isDisable = false,
      this.borderRadius,
      this.textColor = AppColors.white,
      this.boxShadow,
      this.onHighlightChanged})
      : super(key: key);
  final String? text;
  final Color? color;
  final double width;
  final double height;
  final double fontSize;
  final void Function()? onPressed;
  final Color? borderColor;
  final bool isDisable;
  final BorderRadiusGeometry? borderRadius;
  final Color? textColor;
  final List<BoxShadow>? boxShadow;
  final void Function(bool)? onHighlightChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      onHover: onHighlightChanged,
      onHighlightChanged: onHighlightChanged,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          boxShadow: boxShadow,
          color: color,
          borderRadius: borderRadius ?? BorderRadius.circular(25.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child: isDisable
                ? const CircularProgressIndicator(
                    color: AppColors.white,
                  )
                : CustomText(
                    text!,
                    color: textColor,
                    fontSize: fontSize.sp,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
          ),
        ),
      ),
    );
  }
}
