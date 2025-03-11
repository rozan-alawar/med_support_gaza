import 'package:get/get.dart';

import '../utils/countries.dart';
import '../utils/medical_specialties.dart';

extension ValidationExt on String {
  String? get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    if (isEmpty) {
      return "enter_email".tr;
    } else if (!emailRegExp.hasMatch(this)) {
      return "valid_email".tr;
    } else {
      return null;
    }
  }

  String? get isValidPassword {
    if (isEmpty) {
      return "enter_password".tr;
    } else if (length < 8) {
      return "valid_password".tr;
    } else {
      return null;
    }
  }

  String? get isValidName {
    if (isEmpty) {
      return "enter_name".tr;
    } else {
      return null;
    }
  }

  String? get isValidPhone {
    final phoneRegExp = RegExp(r'^\+?\d{10,15}$');
    if (isEmpty) {
      return "enter_phone".tr;
    } else if (!phoneRegExp.hasMatch(this)) {
      return "valid_phone".tr;
    } else {
      return null;
    }
  }

  String? get isValidAge {
    if (isEmpty) {
      return "enter_age".tr;
    } else if (int.tryParse(this) == null || int.parse(this) <= 0) {
      return "valid_age".tr;
    } else {
      return null;
    }
  }

  String? get isValidCountryName {
    if (isEmpty) {
      return "enter_conutry".tr;
    } else if (!countries.contains(capitalizeFirst)) {
      print("countries.contains(this) : ${countries.contains(this)}");
      return "valid_conutry".tr;
    } else {
      return null;
    }
  }

  String? get isValidSpecialtyName {
    if (isEmpty) {
      return "enter_speciality".tr;
    } else if (!medicalSpecialties.contains(this)) {
      return "valid_speciality".tr;
    } else {
      return null;
    }
  }
  
  
  String? get isValidfileName {
    if (isEmpty) {
      return "enter_certificate_file".tr;
    }else {
      return null;
    }
  }
}
