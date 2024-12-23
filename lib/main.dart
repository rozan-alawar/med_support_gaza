import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/core/services/localizations/translation.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await CacheHelper.init(); // Initialize cache helper
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med Support Gaza',
      // locale: TranslationController.initalLang, // Get initial language
      fallbackLocale: const Locale('en'), // Fallback to English
      translations: Translation(), // Language translations
      initialRoute: AppPages.INITIAL, // Set initial route
      getPages: AppPages.routes, // Define routes
    );
  }
}
