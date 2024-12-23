import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/services/localizations/translation_contoller.dart';
import 'package:med_support_gaza/app/core/utils/app_theme.dart';
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
      theme: AppTheme.appTheme,
      fallbackLocale:const Locale('en', 'US'),
      locale: TranslationController.initalLang,
      translations: Translation(), 
      initialRoute: AppPages.INITIAL, 
      getPages: AppPages.routes, 
    );
  }
}
