import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/core/services/localizations/translation_contoller.dart';
import 'package:med_support_gaza/app/core/utils/app_theme.dart';
import 'package:med_support_gaza/app/core/widgets/custem_error_widget.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_service.dart';
import 'package:med_support_gaza/firebase_options.dart';
import 'app/core/services/localizations/translation.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  await CacheHelper.init();

  Get.put<GetStorage>(GetStorage());

  Get.put<AppointmentService>(AppointmentService());
  runApp(const MyApp());
  
await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
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
            getPages: AppPages.routes,
            defaultTransition: Transition.fadeIn,
            onUnknownRoute: (settings) {
              return MaterialPageRoute(
                builder: (context) => ErrorView(
                  message: 'Route ${settings.name} not found',
                ),
              );
            },
            builder: (context, child) {
              return ScrollConfiguration(
                behavior: const ScrollBehavior().copyWith(
                  physics: const BouncingScrollPhysics(),
                ),
                child: child!,
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