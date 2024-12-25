import 'package:flutter/material.dart';

import 'app_colors.dart';

class MyTextStyles {
  static TextStyle hintTextStyle = TextStyle(
    fontSize: 12,
  );

  static TextStyle titleTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 24,
  );

  static TextStyle boldTextStyle = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16.0,
  );

  static TextStyle mediumTextStyle = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
  );

  static const TextStyle lightTextStyle = TextStyle(
    fontWeight: FontWeight.w300,
    fontSize: 16.0,
  );

  static const TextStyle semiBoldTextStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 16.0,
  );

  static TextStyle headingBoldLarge = const TextStyle(
      fontFamily: 'Arial',
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: AppColors.primary);
  static TextStyle bodyRegularCentered = const TextStyle(
    fontFamily: 'Arial',
    fontSize: 24,
    fontWeight: FontWeight.w400,
  );
}
