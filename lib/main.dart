import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/core/services/localizations/translation_contoller.dart';
import 'package:med_support_gaza/app/core/utils/app_theme.dart';
import 'package:med_support_gaza/app/core/widgets/custem_error_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/firebase_options.dart';
import 'app/core/services/localizations/translation.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();

  await CacheHelper.init();

  Get.put<GetStorage>(GetStorage());

  runApp(const MyApp());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Get.put(FirebaseService());
  final firebaseService = Get.find<FirebaseService>();
  await firebaseService.populateSampleData();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return SafeArea(
          child: GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Med Support Gaza',
            theme: AppTheme.appTheme,
            fallbackLocale: const Locale('en', 'US'),
            locale: TranslationController.initalLang,
            translations: Translation(),
         initialRoute: AppPages.INITIAL,
            // initialRoute: Routes.HOME,

            getPages: AppPages.routes,
            defaultTransition: Transition.fadeIn,
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => ErrorView(
                  message: 'Route ${settings.name} not found',
                ),
              );
            },

          ),
        );
      },
    );
  }
}

//rozanalawar@gmail.com
//123123123

//dr.rozan@gmail.com
//rozan2002

//admin@gmail.com
//admin123
