// reomve the firebase code from the DoctorAuthController calss

import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:path/path.dart' as path;

import '../../../core/services/cache_helper.dart';
import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../data/api_paths.dart';
import '../../../data/api_services/doctor_auth_api.dart';
import '../../../routes/app_pages.dart';

/// Controller responsible for handling doctor authentication related operations
class DoctorAuthController extends GetxController {
  // Constants
  static const int otpLength = 4;
  static const int otpResendDelay = 15;
  static const List<String> allowedFileExtensions = ['pdf', 'doc', 'docx'];

  // State management
  final RxBool isLogin = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isConfirmPasswordVisible = false.obs;
  final RxBool isPasswordVisible2 = false.obs;
  final RxString selectedFilePath = ''.obs;
  final RxBool isFileUploading = false.obs;

  // File upload state
  final RxBool isUploading = false.obs;
  final RxString uploadProgress = '0'.obs;
  final RxString uploadError = ''.obs;

  // OTP related state
  final RxList<String> otpDigits = List.generate(otpLength, (index) => '').obs;
  final RxInt timeRemaining = otpResendDelay.obs;
  final RxBool canResend = false.obs;
  final RxString verificationEmail = ''.obs;

  // Error handling state
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  /// Toggles between login and registration view
  void toggleView() => isLogin.value = !isLogin.value;

  /// Toggles password visibility
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  /// Toggles confirm password visibility
  // void toggleConfirmPasswordVisibility() =>
  //      isPasswordVisible2.value = ! isPasswordVisible2.value;

  /// Toggles second password visibility (for confirm password field)
  void togglePasswordVisibility2() =>
      isPasswordVisible2.value = !isPasswordVisible2.value;

  /// Handles file selection for doctor's credentials
  Future<void> pickFile(TextEditingController uploadFileController) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedFileExtensions,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        selectedFilePath.value = file.path ?? '';
        uploadFileController.text = '${file.name}.${file.extension}';

        CustomSnackBar.showCustomSnackBar(
          title: 'file_selected'.tr,
          message: '${'file_selected_message'.tr}: ${file.name}',
        );
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'file_error_message'.tr,
      );
      debugPrint('Error picking file: $e');
    }
  }

  /// Modified signUp method using DioHelper
  Future<void> signUp({
    required String email,
    required String password,
    required String passwordConfirmation,
    required String firstName,
    required String lastName,
    required String phone,
    required String country,
    required String specialty,
    required String gender,
  }) async {
    print(''' fName: $firstName,
      lName: $lastName,
      email: $email,
      password: $password,
      passwordConfirmation: $passwordConfirmation,
      major: $specialty,
      phoneNumber: $phone,
      gender: $gender,
      country: $country,
      certificatePath: ${selectedFilePath.value}''');
    final response = await Get.find<DoctorAuthApi>().register(
      fName: firstName,
      lName: lastName,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
      major: specialty,
      phoneNumber: phone,
      gender: gender,
      country: country,
      certificatePath: selectedFilePath.value,
    );
    Get.offAllNamed(Routes.DOCTOR_LOGIN);
  }

  /// Handles doctor sign in
  Future<void> signIn({required String email, required String password}) async {
    // Use DoctorAuthApi for login
    final response = await Get.find<DoctorAuthApi>().login(
      email: email,
      password: password,
    );
    DoctorModel doctorModel = DoctorModel.fromJson(response.data);
    saveDoctorData(doctorModel);
    Get.offAllNamed(Routes.DOCTOR_HOME);
  }

  void saveDoctorData(DoctorModel doctorModel) {
    CacheHelper.saveData(key: 'isLoggedIn', value: true);
    CacheHelper.saveData(key: 'token', value: doctorModel.token);
    final doctor = doctorModel.doctor;
    if (doctor != null) {
      CacheHelper.saveData(key: 'firstName', value: doctor.firstName);
      CacheHelper.saveData(key: 'lastName', value: doctor.lastName);
      CacheHelper.saveData(key: 'major', value: doctor.major);
      CacheHelper.saveData(key: 'averageRating', value: doctor.averageRating);
      CacheHelper.saveData(key: 'email', value: doctor.email);
      CacheHelper.saveData(key: 'phoneNumber', value: doctor.phoneNumber);
      CacheHelper.saveData(key: 'country', value: doctor.country);
      CacheHelper.saveData(key: 'gender', value: doctor.gender);
      CacheHelper.saveData(key: 'certificate', value: doctor.certificate);
    }
  }

  // Handles forget password request for doctors
  Future<void> forgetPasswordInit({required String email}) async {
    // Use DoctorAuthApi for password reset
    await Get.find<DoctorAuthApi>().forgetPassword(email: email);
    startTimer();
  }

  Future<void> verfiyOTP(String email, int otp) async {
    await Get.find<DoctorAuthApi>().verifyOTP(otp: otp, email: email);
  }

  /// Resets the user's password
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await Get.find<DoctorAuthApi>().resetPassword(
        email: email,
        password: newPassword,
        passwordConfirmation: confirmPassword);
    // Navigate to login
    Get.offAllNamed(Routes.DOCTOR_LOGIN);
  }

  Future<void> signOut() async {
    await Get.find<DoctorAuthApi>()
        .logout(token: CacheHelper.getData(key: 'token'));
    CacheHelper.removeData(key: 'isLoggedIn');
    CacheHelper.removeData(key: 'token');
    Get.offAllNamed(Routes.DOCTOR_LOGIN);
  }

  /// Starts OTP timer countdown
  void startTimer() {
    timeRemaining.value = otpResendDelay;
    canResend.value = false;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        timer.cancel();
        canResend.value = true;
      }
    });
  }

  /// Sets OTP digit at specified index
  void setDigit(int index, String value) {
    if (index >= 0 && index < otpLength) {
      otpDigits[index] = value;
    }
  }

  /// Handles OTP resend request
  Future<void> resendOTP(String email) async {
    try {
      isLoading.value = true;
      await forgetPasswordInit(email: email);
      otpDigits.assignAll(List.generate(otpLength, (index) => ''));
    } finally {
      isLoading.value = false;
    }
  }

  /// Verifies entered OTP
  Future<void> verifyOTP() async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Combine OTP digits
      final otp = otpDigits.join();

      if (otp.length != otpLength) {
        throw Exception('Please enter all OTP digits');
      }

      // Here you would typically verify the OTP with your backend
      // For now, we'll just navigate to reset password
      await Future.delayed(
          const Duration(seconds: 1)); // Simulated verification

      Get.toNamed(Routes.DOCTOR_RESET_PASSWORD);
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Reset verification state
    otpDigits.assignAll(List.generate(otpLength, (index) => ''));
    timeRemaining.value = otpResendDelay;
    canResend.value = false;
    verificationEmail.value = '';
    super.onClose();
  }
}

// /// Controller responsible for handling doctor authentication related operations
// class DoctorAuthController extends GetxController {
//   // Constants
//   static const int otpLength = 4;
//   static const int otpResendDelay = 15;
//   static const List<String> allowedFileExtensions = ['pdf', 'doc', 'docx'];

//   // Firebase instances
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // State management
//   final RxBool isLogin = true.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool isPasswordVisible = false.obs;
//   final RxBool isConfirmPasswordVisible = false.obs;
//   final RxBool isPasswordVisible2 = false.obs;
//   final RxString selectedFilePath = ''.obs;
//   final RxBool isFileUploading = false.obs;

//   // File upload state
//   final RxBool isUploading = false.obs;
//   final RxString uploadProgress = '0'.obs;
//   final RxString uploadError = ''.obs;

//   // OTP related state
//   final RxList<String> otpDigits = List.generate(otpLength, (index) => '').obs;
//   final RxInt timeRemaining = otpResendDelay.obs;
//   final RxBool canResend = false.obs;

//   // Error handling state
//   final RxBool hasError = false.obs;
//   final RxString errorMessage = ''.obs;

//   /// Toggles between login and registration view
//   void toggleView() => isLogin.value = !isLogin.value;

//   /// Toggles password visibility
//   void togglePasswordVisibility() =>
//       isPasswordVisible.value = !isPasswordVisible.value;

//   /// Toggles confirm password visibility
//   void toggleConfirmPasswordVisibility() =>
//       isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

//   /// Toggles second password visibility (for confirm password field)
//   void togglePasswordVisibility2() =>
//       isPasswordVisible2.value = !isPasswordVisible2.value;

//   /// Handles file selection for doctor's credentials
//   Future<void> pickFile(TextEditingController uploadFileController) async {
//     try {
//       FilePickerResult? result = await FilePicker.platform.pickFiles(
//         type: FileType.custom,
//         allowedExtensions: allowedFileExtensions,
//       );

//       if (result != null && result.files.isNotEmpty) {
//         final file = result.files.first;
//         selectedFilePath.value = file.path ?? '';
//         uploadFileController.text = '${file.name}.${file.extension}';

//         CustomSnackBar.showCustomSnackBar(
//           title: 'file_selected'.tr,
//           message: '${'file_selected_message'.tr}: ${file.name}',
//         );
//       }
//     } catch (e) {
//       CustomSnackBar.showCustomErrorSnackBar(
//         title: 'Error'.tr,
//         message: 'file_error_message'.tr,
//       );
//       debugPrint('Error picking file: $e');
//     }
//   }

//   /// Uploads a document file to Firebase Storage
//   Future<String?> _uploadDocumentFile(File file, String userId) async {
//     try {
//       isUploading.value = true;
//       uploadError.value = '';

//       final storageRef = FirebaseStorage.instance
//           .ref()
//           .child('doctor_documents')
//           .child(userId)
//           .child('medical_certificate${file.path.split('.').last}');

//       final uploadTask = storageRef.putFile(file);

//       uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
//         uploadProgress.value =
//             ((snapshot.bytesTransferred / snapshot.totalBytes) * 100)
//                 .toStringAsFixed(2);
//       });

//       await uploadTask;
//       final downloadUrl = await storageRef.getDownloadURL();

//       isUploading.value = false;
//       return downloadUrl;
//     } catch (e) {
//       isUploading.value = false;
//       uploadError.value = e.toString();
//       debugPrint('Error uploading document: $e');
//       return null;
//     }
//   }

//   /// Modified signUp method using DioHelper
//   Future<void> signUp({
//     required String email,
//     required String password,
//     required String passwordConfirmation,
//     required String firstName,
//     required String lastName,
//     required String phone,
//     required String country,
//     required String specialty,
//     required String gender,
//   }) async {

//     final response = await Get.find<DoctorAuthApi>().register(
//       fName: firstName,
//       lName: lastName,
//       email: email,
//       password: password,
//       passwordConfirmation: passwordConfirmation,
//       major: specialty,
//       phoneNumber: phone,
//       gender: gender,
//       country: country,
//       certificatePath: selectedFilePath.value,
//     );
//     Get.offAllNamed(Routes.DOCTOR_LOGIN);
//   }

//   // /// Handles doctor registration with all required fields
//   // Future<void> signUp({
//   //   required String email,
//   //   required String password,
//   //   required String firstName,
//   //   required String lastName,
//   //   required String phone,
//   //   required String country,
//   //   required String specialty,
//   //   required File? documentFile,
//   //   String? age,
//   //   String? gender,
//   // }) async {
//   //   try {
//   //     isLoading.value = true;
//   //     hasError.value = false;
//   //     errorMessage.value = '';

//   //     // Create user account
//   //     final userCredential = await _auth.createUserWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );

//   //     String? documentUrl;
//   //     if (documentFile != null) {
//   //       documentUrl = await _uploadDocumentFile(documentFile, userCredential.user!.uid);
//   //       if (documentUrl == null && uploadError.value.isNotEmpty) {
//   //         throw Exception('Failed to upload document: ${uploadError.value}');
//   //       }
//   //     }

//   //     // Create doctor profile
//   //     await _firestore.collection('doctors').doc(userCredential.user!.uid).set({
//   //       'id': userCredential.user!.uid,
//   //       'firstName': firstName,
//   //       'lastName': lastName,
//   //       'email': email,
//   //       'phone': phone,
//   //       'country': country,
//   //       'specialty': specialty,
//   //       'documentUrl': documentUrl,
//   //       'age': age,
//   //       'gender': gender,
//   //       'createdAt': FieldValue.serverTimestamp(),
//   //       'isVerified': false,
//   //     });

//   //     CustomSnackBar.showCustomSnackBar(
//   //       title: 'Success'.tr,
//   //       message: 'Account_created_successfully'.tr,
//   //     );
//   //     Get.offNamed(Routes.DOCTOR_LOGIN);
//   //   } on FirebaseAuthException catch (e) {
//   //     _handleFirebaseAuthError(e);
//   //   } catch (e) {
//   //     hasError.value = true;
//   //     errorMessage.value = e.toString();
//   //     CustomSnackBar.showCustomErrorSnackBar(
//   //       title: 'Error'.tr,
//   //       message: e.toString(),
//   //     );
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//   /// Handles doctor sign in
//   Future<void> signIn({required String email, required String password}) async {
//     try {
//       isLoading.value = true;

//       await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       CustomSnackBar.showCustomSnackBar(
//         title: 'Success'.tr,
//         message: 'Login successful'.tr,
//       );
//       Get.offAllNamed(Routes.DOCTOR_HOME);
//     } on FirebaseAuthException catch (e) {
//       _handleFirebaseAuthError(e);
//     } catch (e) {
//       CustomSnackBar.showCustomErrorSnackBar(
//         title: 'Error'.tr,
//         message: e.toString(),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Handles forget password request for doctors
//   Future<void> forgetPassword({required String email}) async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;
//       errorMessage.value = '';

//       // Send password reset email
//       await _auth.sendPasswordResetEmail(email: email);

//       // Show success message
//       CustomSnackBar.showCustomSnackBar(
//         title: 'Success',
//         message: 'Password reset email sent successfully',
//       );

//       isLoading.value = false;
//     } catch (e) {
//       isLoading.value = false;
//       hasError.value = true;
//       errorMessage.value = e.toString();

//       CustomSnackBar.showCustomErrorSnackBar(
//         title: 'Error',
//         message: 'Failed to send password reset email. Please try again.',
//       );
//       debugPrint('Error in forgetPassword: $e');
//     }
//   }

//   /// Initiates password reset process
//   Future<void> forgetPasswordInit(String email) async {
//     try {
//       isLoading.value = true;
//       await forgetPassword(email: email);

//       CustomSnackBar.showCustomSnackBar(
//         title: 'Success'.tr,
//         message: 'Password reset email sent'.tr,
//       );
//       startTimer();
//     } on FirebaseAuthException catch (e) {
//       _handleFirebaseAuthError(e);
//     } catch (e) {
//       CustomSnackBar.showCustomErrorSnackBar(
//         title: 'Error'.tr,
//         message: e.toString(),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Resets the user's password
//   Future<void> resetPassword({
//     required String newPassword,
//     required String confirmPassword,
//   }) async {
//     try {
//       if (newPassword != confirmPassword) {
//         throw Exception('Passwords do not match');
//       }

//       isLoading.value = true;
//       hasError.value = false;
//       errorMessage.value = '';

//       final user = _auth.currentUser;
//       if (user == null) {
//         throw Exception('No user is currently signed in');
//       }

//       // Update password
//       await user.updatePassword(newPassword);

//       // Show success message
//       CustomSnackBar.showCustomSnackBar(
//         title: 'Success'.tr,
//         message: 'Password_updated_successfully'.tr,
//       );

//       // Navigate to login
//       Get.offAllNamed(Routes.DOCTOR_LOGIN);
//     } catch (e) {
//       hasError.value = true;
//       errorMessage.value = e.toString();

//       CustomSnackBar.showCustomErrorSnackBar(
//         title: 'Error'.tr,
//         message: 'Failed_to_update_password'.tr,
//       );
//       debugPrint('Error in resetPassword: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Handles Firebase authentication errors
//   void _handleFirebaseAuthError(FirebaseAuthException e) {
//     String errorMessage = '';
//     switch (e.code) {
//       case 'user-not-found':
//         errorMessage = 'No user found for this email.'.tr;
//         break;
//       case 'wrong-password':
//         errorMessage = 'Incorrect password.'.tr;
//         break;
//       case 'email-already-in-use':
//         errorMessage = 'Email is already registered.'.tr;
//         break;
//       case 'invalid-email':
//         errorMessage = 'Invalid email address.'.tr;
//         break;
//       case 'weak-password':
//         errorMessage = 'Password is too weak.'.tr;
//         break;
//       default:
//         errorMessage = 'An error occurred: ${e.message}'.tr;
//     }
//     CustomSnackBar.showCustomErrorSnackBar(
//       title: 'Error'.tr,
//       message: errorMessage,
//     );
//   }

//   /// Starts OTP timer countdown
//   void startTimer() {
//     timeRemaining.value = otpResendDelay;
//     canResend.value = false;
//     Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (timeRemaining.value == 0) {
//         canResend.value = true;
//         timer.cancel();
//       } else {
//         timeRemaining.value--;
//       }
//     });
//   }

//   /// Sets OTP digit at specified index
//   void setDigit(int index, String value) {
//     if (value.length <= 1 && index < otpLength) {
//       otpDigits[index] = value;
//     }
//   }

//   /// Handles OTP resend request
//   Future<void> resendOTP(String email) async {
//     try {
//       isLoading.value = true;
//       await forgetPasswordInit(email);
//       otpDigits.assignAll(List.generate(otpLength, (index) => ''));
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   /// Verifies entered OTP
//   Future<void> verifyOTP() async {
//     try {
//       isLoading.value = true;
//       final otp = otpDigits.join();

//       if (otp.length != otpLength) {
//         throw 'Please enter complete OTP';
//       }

//       // Add actual OTP verification logic here
//       await Future.delayed(const Duration(seconds: 2));
//       Get.offAllNamed(Routes.DOCTOR_RESET_PASSWORD);
//     } catch (e) {
//       CustomSnackBar.showCustomErrorSnackBar(
//         title: 'Error'.tr,
//         message: e.toString(),
//       );
//     } finally {
//       isLoading.value = false;
//     }
//   }
// }
