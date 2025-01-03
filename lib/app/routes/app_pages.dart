import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/auth/views/patient_forget_password_view.dart';
import 'package:med_support_gaza/app/modules/auth/views/patient_new_password_view.dart';
import 'package:med_support_gaza/app/modules/auth/views/verfication_view.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/doctor_auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/doctor_forget_password_view.dart';
import '../modules/auth/views/doctor_login_view.dart';
import '../modules/auth/views/doctor_reset_password_view.dart';
import '../modules/auth/views/doctor_signup_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/patient_home_view.dart';
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
      page: () =>  PatientHomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.FORGET_PASSWORD,
      page: () => PatientForgetPasswordView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.VERIFICATION,
      page: () =>  VerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => PatientResetPasswordView(),
      // binding: AuthBinding(),
    ),
    GetPage(
        name: _Paths.DOCTOR_SIGNUP,
        page: () => DoctorSignUpView(),
        binding: DoctorAuthBinding()),
    GetPage(
        name: _Paths.DOCTOR_LOGIN,
        page: () => DoctroLoginView(),
        binding: DoctorAuthBinding()),
    GetPage(
        name: _Paths.DOCTOR_FORGET_PASSWORD,
        page: () => DoctorForgetPasswordView(),
        binding: DoctorAuthBinding()),
    GetPage(
        name: _Paths.DOCTOR_RESET_PASSWORD,
        page: () => DoctroResetPasswordView(),
        binding: DoctorAuthBinding()),
  ];
}
