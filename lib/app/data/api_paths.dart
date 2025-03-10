// ignore_for_file: non_constant_identifier_names

class Links {
  static var baseLink =
      'http://medsupport-gaza-cfd5c72a1744.herokuapp.com/api/';
  static var PATIENT_LOGIN = 'patient/login';
  static var PATIENT_REGISTER = 'patient/register';
  static var PATIENT_LOGOUT = 'patient/logout';
  static var PATIENT_PROFILE = 'patient/profile';
  static var FORGET_PASSWORD = 'forgot-password';
  static var RESET_PASSWORD = 'reset-password';
  static var VERIFY_OTP = 'verify-otp';

  static var GET_DOCTORS = 'doctors/search';
  static var SEARCH_DOCTOR = 'doctors/search';

  static var doctorRegister = 'doctor/register';
  static var doctorLogin = 'doctor/login';
  static var getDoctorSpecialties = 'doctor/specialties';
  static var getDoctorProfile = 'doctor/profile';
  static var getDoctorAppointments = 'doctor/appointments';
  static var getHealthTips = 'health_tips';
  static var getHealthArticles = 'health_articles';
  static var getPatientProfile = 'patient/profile';
  static var updatePatientProfile = 'patient/update-profile';
  static var getPatientDoctors = 'patient/doctors';
  static var getPatientAppointments = 'patient/appointments';
  static var getPatientConsultations = 'patient/consultations';
  static var getPatientConsultationDetails = 'patient/consultation';
  static var getPatientPrescriptions = 'patient/prescriptions';
  static var getPatientPrescriptionDetails = 'patient/prescription';
  static var verify = '/verify';
  static var forgotPassword = '/forgot-password';
  static var resetPassword = '/reset-password';
  static var verifyOTP = 'verify-otp';
  static var doctorLogout = '/doctor/logout';
}
