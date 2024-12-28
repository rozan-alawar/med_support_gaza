import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/views/patient_onboarding_view.dart';
import '../modules/onboarding/views/doctor_onboarding_view.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/user_role_selection/views/user_role_selection.dart';

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
      name: _Paths.USER_ROLE_SELECTION,
      page: () => UserRoleSelectionView(),
    ),
    GetPage(
      name: _Paths.PATIENT_ONBOARDING,
      page: () => PatientOnboardingView(),
    ),
    GetPage(
      name: _Paths.DOCTRO_ONBOARDING,
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
  ];
}
