// lib/app/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:med_support_gaza/app/core/utils/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return  ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Color(0xFF00796B), // Custom primary color
        scaffoldBackgroundColor: Colors.white, // Background color
        
        buttonTheme: ButtonThemeData(
          buttonColor: Color(0xFF00796B),
          textTheme: ButtonTextTheme.primary,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color(0xFF004D40)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color(0xFF00796B)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Color(0xFF004D40)),
          ),
        ),
      );
      }
}