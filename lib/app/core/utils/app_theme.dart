// lib/app/core/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get appTheme {
    return  ThemeData(
        primarySwatch: Colors.teal,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: const Color(0xFF00796B), // Custom primary color
        scaffoldBackgroundColor: Colors.white, // Background color
        
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF00796B),
          textTheme: ButtonTextTheme.primary,
        ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF1f6c42)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF1f6c42)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Color(0xFF1f6c42)),
        ),
      ),

      );
      }
}