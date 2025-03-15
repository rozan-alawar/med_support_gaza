// ignore_for_file: non_constant_identifier_names

class Links {
  static var baseLink =
      'http://medsupport-gaza-cfd5c72a1744.herokuapp.com/api/';

  static var PATIENT_LOGIN = 'patient/login';
  static var PATIENT_REGISTER = 'patient/register';
  static var PATIENT_LOGOUT = 'patient/logout';
  static var FORGET_PASSWORD = 'forgot-password';
  static var RESET_PASSWORD = 'reset-password';
  static var VERIFY_OTP = 'verify-otp';

  static var PATIENT_PROFILE = 'patient/profile';
  static var UPDATE_PROFILE = 'patient/update-profile';

  static var GET_DOCTORS = 'doctors/search';
  static var SEARCH_DOCTOR = 'doctors/search';

  static var ADMIN_LOGIN = 'login';
  static var ADMIN_LOGOUT = 'logout';

  static var GET_ARTICLES = 'articles';

  static var GET_DOCTORS_SPECIALIZATIONS = 'patient/specializations';
  static var GET_DOCTORS_BY_SPECIALIZATION = 'patient/doctors';



  static var doctorRegister = 'doctor/register';
  static var doctorLogin = 'doctor/login';
  static var getDoctorSpecialties = 'doctor/specialties';
  static var getDoctorProfile = 'doctor/profile';
  static var getDoctorAppointments = 'doctor/appointments';

  static var verify = '/verify';
  static var forgotPassword = '/forgot-password';
  static var resetPassword = '/reset-password';
  static var verifyOTP = 'verify-otp';
  static var doctorLogout = '/logout';
  static var doctorProfile = '/doctor/profile';
  static var doctorUpdateProfile = '/doctor/update-profile';
  static var doctorAddSchedule  = '/doctor/schedule';
  static var doctorAppointments= 'doctor/appointments';
  static var doctorDeleteAppointment= 'doctor/appointment';
  static var doctorPendingAppointments = 'doctor/appointments/pending';
  static var doctorRejectAppointment = 'doctor/appointment/reject';
  static var doctorAcceptAppointment = 'doctor/appointment/accept';

}
