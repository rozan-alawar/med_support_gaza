// lib/app/data/firebase_services/firebase_handler.dart

import 'package:get/get.dart';

class FirebaseErrorHandler {
  static String getErrorMessage(dynamic error) {
    if (error == null) return 'Unknown error occurred'.tr;

    String errorString = error.toString();
    String errorCode = 'unknown';

    if (errorString.contains('firebase_auth/')) {
      try {
        errorCode = errorString.split('firebase_auth/')[1].split(']')[0];
      } catch (_) {
        return errorString;
      }
    }

    switch (errorCode) {
      case 'invalid-email':
        return 'The email address is badly formatted'.tr;
      case 'wrong-password':
        return 'Incorrect password'.tr;
      case 'user-not-found':
        return 'No user found with this email'.tr;
      case 'user-disabled':
        return 'This user account has been disabled'.tr;
      case 'email-already-in-use':
        return 'An account already exists with this email'.tr;
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled. Please contact support'.tr;
      case 'weak-password':
        return 'The password provided is too weak'.tr;
      case 'configuration-not-found':
        return 'Firebase configuration error. Please try again later'.tr;
      case 'network-request-failed':
        return 'Network error. Please check your connection'.tr;
      case 'too-many-requests':
        return 'Too many attempts. Please try again later'.tr;
      case 'unknown':
        if (errorString.contains('CONFIGURATION_NOT_FOUND')) {
          return 'Firebase configuration error. Please try again later'.tr;
        }
        return 'An unknown error occurred. Please try again'.tr;
      default:
        return errorString;
    }
  }
}