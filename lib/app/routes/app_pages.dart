import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/auth/views/patient_forget_password_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/patient_onboarding_view.dart';
import '../modules/onboarding/views/doctor_onboarding_view.dart';
import '../modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH,
      page: () => SplashView(),
    ),
    GetPage(
      name: _Paths.PATIENTONBOARDING,
      page: () => PatientOnboardingView(),
    ),
    GetPage(
      name: _Paths.DOCTROONBOARDING,
      page: () => DoctorOnboardingView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () =>  PatientForgetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () =>  PatientForgetPasswordView(),
      binding: AuthBinding(),
    ),
  ];
}
