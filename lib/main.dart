import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/core/services/connection_manager_service.dart';
import 'package:med_support_gaza/app/core/services/localizations/translation_contoller.dart';
import 'package:med_support_gaza/app/core/utils/app_theme.dart';
import 'package:med_support_gaza/app/core/widgets/custem_error_widget.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/core/widgets/no_internet_connection_widget.dart';
import 'package:med_support_gaza/app/data/api_services/doctor_auth_api.dart';
import 'package:med_support_gaza/app/data/firebase_services/chat_services.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_helper.dart';
import 'package:med_support_gaza/app/data/network_helper/dio_client.dart';
import 'package:med_support_gaza/firebase_options.dart';
import 'app/core/services/localizations/translation.dart';
import 'app/modules/appointment_booking/controllers/appointment_booking_controller.dart';
import 'app/routes/app_pages.dart';

Future<void> initializeServices() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await CacheHelper.init();

  // Initialize GetX services
  Get.lazyPut(() => GetStorage());
  await Get.putAsync(() => ConnectionManagerService().init());

  // api services initialization
  Get.lazyPut(() => Dio(), fenix: true);
  Get.lazyPut(() => DioClient(Get.find<Dio>()), fenix: true);
  Get.lazyPut(() => DoctorAuthApi(), fenix: true);

  // Initialize DioHelper
  DioHelper.init();
  ChatService().monitorAppointmentsStatus();
}

void main() async {
  await initializeServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) => _buildApp(),
    );
  }
}

Widget _buildApp() {
  return Obx(() {
    bool isConnected = Get.find<ConnectionManagerService>().isConnected.value;

    if (!isConnected) {
      // CustomSnackBar.showCustomErrorSnackBar(
      //   title: 'No Internet Connection',
      //   message: 'Please check your internet connection.',
      // );
      return GetMaterialApp(home:  NoInternetWidget());
    }

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
        onUnknownRoute: _handleUnknownRoute,
      ),
    );
  });
}

Route<dynamic> _handleUnknownRoute(RouteSettings settings) {
  return MaterialPageRoute(
    builder: (context) => ErrorView(
      message: 'Route ${settings.name} not found',
    ),
  );
}

//rozanalawar@gmail.com
//123123123

//herezsaja2020@gmail.com
//password123

//admin1@gmail.com
//password123
