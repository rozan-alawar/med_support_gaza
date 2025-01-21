import 'package:get/get.dart';
import 'package:med_support_gaza/app/modules/admin_home/bindings/home_biding.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_auth.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_home.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_new_article_view.dart';
import 'package:med_support_gaza/app/modules/admin_home/view/pages/admin_notification_view.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/views/doctor_booking_view.dart';
import 'package:med_support_gaza/app/modules/profile/views/pages/doctor_edit_profile_view.dart';
import 'package:med_support_gaza/app/modules/profile/views/pages/doctor_profile_view.dart';

import '../modules/appointment_booking/bindings/appointment_booking_binding.dart';
import '../modules/appointment_booking/bindings/doctor_appointment_management_binding.dart';
import '../modules/appointment_booking/views/appointment_booking_view.dart';
import '../modules/appointment_booking/views/daily_schedule_view.dart';
import '../modules/appointment_booking/views/doctor_appointment_management_view.dart';
import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/bindings/doctor_auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/auth/views/doctor_forget_password_view.dart';
import '../modules/auth/views/doctor_login_view.dart';
import '../modules/auth/views/doctor_reset_password_view.dart';
import '../modules/auth/views/doctor_signup_view.dart';
import '../modules/auth/views/doctor_verifcation_view.dart';
import '../modules/auth/views/patient_forget_password_view.dart';
import '../modules/auth/views/patient_new_password_view.dart';
import '../modules/auth/views/verfication_view.dart';
import '../modules/consultation/bindings/consultation_binding.dart';
import '../modules/consultation/views/consultation_view.dart';
import '../modules/home/bindings/doctor_home_binding.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/doctor_home_view.dart';
import '../modules/home/views/patient_home_view.dart';
import '../modules/onboarding/views/doctor_onboarding_view.dart';
import '../modules/onboarding/views/patient_onboarding_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/pages/patient_edit_profile_view.dart';
import '../modules/profile/views/pages/patient_profile_view.dart';
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
      page: () => const PatientOnboardingView(),
    ),
    GetPage(
      name: _Paths.DOCTRO_ONBOARDING,
      page: () => const DoctorOnboardingView(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const PatientHomeView(),
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
      page: () => VerificationView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.NEW_PASSWORD,
      page: () => PatientResetPasswordView(),
      // binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.APPOINTMENT_BOOKING,
      page: () => const AppointmentBookingView(),
      binding: AppointmentBookingBinding(),
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
    GetPage(
        name: _Paths.DOCTOR_VERIFICATION,
        page: () => DoctorVerifcationView(),
        binding: DoctorAuthBinding()),
    GetPage(
        name: _Paths.PATIENT_PROFILE,
        page: () => const PatientProfileView(),
        binding: DoctorAuthBinding()),
    // Add the route in app_pages.dart
    GetPage(
      name: Routes.EDIT_PATIENT_PROFILE,
      page: () => const PatientEditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.CONSULTATION,
      page: () => const ConsultationView(),
      binding: ConsultationBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_APPOINTMENT_MANAGEMENT,
      page: () => const DoctorAppointmentManagementView(),
      binding: DoctorAppointmentManagementBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_HOME,
      page: () => const DocotrHomeView(),
      binding: DoctorHomeBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_AUTH,
      page: () => AdminAuth(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_HOME,
      page: () => const AdminHome(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_PROFILE,
      page: () => const DoctorProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_DOCTOR_PROFILE,
      page: () => const DoctorEditProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_DAILY_SCHEDULE,
      page: () => const DailyScheduleView(),
      binding: DoctorAppointmentManagementBinding(),
    ),
    GetPage(
      name: _Paths.ADD_CONTETNT,
      page: () => const AddNewArticle(),
      binding: AdminBinding(),
    ),
    GetPage(
      name: _Paths.DOCTOR_BOOKING_MANAGEMENT,
      page: () => const DoctorBookingView(),
      binding: DoctorAppointmentManagementBinding(),
    ),

    GetPage(
      name: _Paths.ADMIN_NOTIFICATION,
      page: () => const AdminNotificationView(),
      binding: AdminBinding(),
    ),
  ];
}
