// import 'dart:async';

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
// import 'package:med_support_gaza/app/data/api_services/patient_auth_api.dart';
// import 'package:med_support_gaza/app/data/firebase_services/firebase_handler.dart';
// import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
// import 'package:med_support_gaza/app/data/models/patient_model.dart';
// import 'package:med_support_gaza/app/routes/app_pages.dart';

// class AuthController extends GetxController {
//   static const int otpLength = 4;
//   static const int otpTimerDuration = 15;

//   final FirebaseService _firebaseService = Get.find<FirebaseService>();
//   Timer? _otpTimer;

//   // Observable variables
//   final RxBool isLogin = true.obs;
//   final RxBool isPasswordVisible = true.obs;
//   final RxBool isLoading = false.obs;
//   final RxBool hasError = false.obs;
//   final Rx<User?> currentUser = Rx<User?>(null);
//   final Rx<PatientModel?> patientData = Rx<PatientModel?>(null);

//   // OTP Related
//   final RxList<String> otpDigits = List.generate(otpLength, (index) => '').obs;
//   final RxInt timeRemaining = otpTimerDuration.obs;
//   final RxBool canResend = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initializeAuth();
//   }

//   @override
//   void onClose() {
//     _otpTimer?.cancel();
//     super.onClose();
//   }

//   void _initializeAuth() {
//     startTimer();
//     currentUser.bindStream(_firebaseService.authStateChanges);
//     ever(currentUser, _handleAuthChanged);
//   }

//   void toggleView() => isLogin.value = !isLogin.value;

//   void togglePasswordVisibility() =>
//       isPasswordVisible.value = !isPasswordVisible.value;

//   Future<void> _handleAuthChanged(User? user) async {
//     if (user != null) {
//       try {
//         patientData.value = await _firebaseService.getPatientData(user.uid);
//       } catch (e) {
//         _handleError('Error'.tr, e.toString());
//       }
//     } else {
//       patientData.value = null;
//     }
//   }

//   Future<void> signUp({
//     required String firstName,
//     required String lastName,
//     required String phoneNo,
//     required String email,
//     required String age,
//     required String gender,
//     required String country,
//     required String password,
//   }) async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;

//       final patient = PatientModel(
//         firstName: firstName,
//         lastName: lastName,
//         email: email,
//         phoneNo: phoneNo,
//         age: age,
//         gender: gender,
//         country: country,
//       );

//       await _firebaseService.signUpWithEmailAndPassword(
//         email: email,
//         password: password,
//         patient: patient,
//       );

//       _showSuccessMessage('AccountCreatedSuccessfully'.tr);
//       Get.offAllNamed(Routes.HOME);
//     } catch (e) {
//       hasError.value = true;
//       _handleError(
//           'Error'.tr, FirebaseErrorHandler.getErrorMessage(e.toString()));
//     } finally {
//       isLoading.value = false;
//     }
//   }
// //------------------------ SIGN IN -----------------------------

//   // Future<void> signIn({
//   //   required String email,
//   //   required String password,
//   // }) async {
//   //   try {
//   //     isLoading.value = true;
//   //     hasError.value = false;

//   //     await _firebaseService.signInWithEmailAndPassword(
//   //       email: email,
//   //       password: password,
//   //     );
//   //     Get.offAllNamed(Routes.HOME);
//   //   } catch (e) {
//   //     hasError.value = true;
//   //     _handleError('Error'.tr, FirebaseErrorHandler.getErrorMessage(e.toString()));
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }

//   //------------------------ SIGN IN -----------------------------

//   void signIn({
//     required String email,
//     required String password,
//   }) {
//     PatientAuthAPIService.signIn(
//       email: email,
//       password: password,
//       onSuccess: (response) {
//         isLoading.value = false;
//       },
//       onError: (e) {
//         isLoading.value = false;
//         hasError.value = true;
//         _handleError('Error'.tr, e.message);
//       },
//       onLoading: () {
//         isLoading.value = true;
//       },
//     );
//   }

//   Future<void> forgetPassword({required String email}) async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;

//       await _firebaseService.sendPasswordResetEmail(email);
//       Get.toNamed(Routes.VERIFICATION);
//     } catch (e) {
//       hasError.value = true;
//       _handleError('Error'.tr, e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void startTimer() {
//     _otpTimer?.cancel();
//     timeRemaining.value = otpTimerDuration;
//     canResend.value = false;

//     _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (timeRemaining.value == 0) {
//         canResend.value = true;
//         timer.cancel();
//       } else {
//         timeRemaining.value--;
//       }
//     });
//   }

//   void setDigit(int index, String value) {
//     if (value.length <= 1 && index < otpLength) {
//       otpDigits[index] = value;
//     }
//   }

//   void resendOTP() {
//     otpDigits.assignAll(List.generate(otpLength, (index) => ''));
//     startTimer();
//   }

//   Future<void> verifyOTP() async {
//     try {
//       isLoading.value = true;
//       hasError.value = false;

//       final otp = otpDigits.join();
//       if (otp.length != otpLength) {
//         throw 'PleaseEnterCompleteOTP'.tr;
//       }

//       // Add your OTP verification logic here

//       Get.offAllNamed(Routes.NEW_PASSWORD);
//     } catch (e) {
//       hasError.value = true;
//       _handleError('Error'.tr, e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   void _handleError(String title, String message) {
//     CustomSnackBar.showCustomErrorSnackBar(
//       title: title,
//       message: message,
//     );
//   }

//   void _showSuccessMessage(String message) {
//     CustomSnackBar.showCustomErrorSnackBar(
//       message: message,
//       color: Colors.green,
//       title: 'Success'.tr,
//     );
//   }
// }

// INTEGRATE WITH API
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/services/cache_helper.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/api_services/patient_auth_api.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class AuthController extends GetxController {
  static const int otpLength = 4;
  static const int otpTimerDuration = 15;

  Timer? _otpTimer;

  // Observable variables
  final RxBool isLogin = true.obs;
  final RxBool isPasswordVisible = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  PatientModel? currentUser;

  // OTP Related
  final RxList<String> otpDigits = List.generate(otpLength, (index) => '').obs;
  final RxInt timeRemaining = otpTimerDuration.obs;
  final RxBool canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    // UserModel? user = json.decode(CacheHelper.getData(key: 'user'));
    // currentUser = user;
    startTimer();
  }

  @override
  void onClose() {
    _otpTimer?.cancel();
    super.onClose();
  }

  void toggleView() => isLogin.value = !isLogin.value;

  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

//------------------------ SIGN UP -----------------------------

  void signUp({
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String email,
    required String age,
    required String gender,
    required String address,
    required String password,
  }) {
    PatientAuthAPIService.signUp(
      email: email,
      age: age,
      firstName: firstName,
      lastName: lastName,
      gender: gender,
      passwordConfirmation: password,
      address: address,
      password: password,
      username: firstName + lastName,
      phoneNumber: phoneNo,
      onSuccess: (response) {
        isLoading.value = false;
        AuthResponseModel loginResponse =
            AuthResponseModel.fromJson(response.data);
        _showSuccessMessage(loginResponse.message);
        toggleView();
      },
      onError: (e) {
        isLoading.value = false;
        hasError.value = true;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //------------------------ SIGN IN -----------------------------

  void signIn({
    required String email,
    required String password,
  }) {
    PatientAuthAPIService.signIn(
      email: email,
      password: password,
      onSuccess: (response) {
        isLoading.value = false;
        print(response);
        AuthResponseModel loginResponse =
            AuthResponseModel.fromJson(response.data);
        _showSuccessMessage(loginResponse.message);
        // Save login status
        CacheHelper.saveData(key: 'isLoggedIn', value: true);

        // Save user data
        currentUser = loginResponse.patient;
        CacheHelper.saveData(key: 'user', value: json.encode(currentUser!));

        // Save token
        CacheHelper.saveData(key: 'token', value: loginResponse.token);
        Get.offAllNamed(Routes.HOME);
      },
      onError: (e) {
        isLoading.value = false;
        hasError.value = true;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }
  //------------------------ FORGET PASSWORD -----------------------------

  Future<void> forgetPassword({required String email}) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      PatientAuthAPIService.forgetPassword(
        email: email,
        onSuccess: (response) {
          isLoading.value = false;
          _showSuccessMessage(response.data['message']);
          Get.toNamed(Routes.VERIFICATION);
        },
        onError: (e) {
          isLoading.value = false;
          hasError.value = true;
          _handleError('Error'.tr, e.message);
        },
        onLoading: () {
          isLoading.value = true;
        },
      );
      Get.toNamed(Routes.VERIFICATION, arguments: {email});
    } catch (e) {
      hasError.value = true;
      _handleError('Error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //------------------------ RESET PASSWORD -----------------------------

  Future<void> resetPassword(
      {required String email, required String password}) async {
    isLoading.value = true;
    hasError.value = false;

    PatientAuthAPIService.resetPassword(
      email: email,
      newPassword: password,
      confirmPassword: password,
      onSuccess: (response) {
        isLoading.value = false;
        _showSuccessMessage(response.data['message']);
        Get.offAllNamed(Routes.AUTH);
      },
      onError: (e) {
        isLoading.value = false;
        hasError.value = true;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //------------------------ VERIFY OTP -----------------------------

  void startTimer() {
    _otpTimer?.cancel();
    timeRemaining.value = otpTimerDuration;
    canResend.value = false;

    _otpTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value == 0) {
        canResend.value = true;
        timer.cancel();
      } else {
        timeRemaining.value--;
      }
    });
  }

  void setDigit(int index, String value) {
    if (value.length <= 1 && index < otpLength) {
      otpDigits[index] = value;
    }
  }

  void resendOTP() {
    otpDigits.assignAll(List.generate(otpLength, (index) => ''));
    startTimer();
  }

  Future<void> verifyOTP({required String email}) async {
    try {
      isLoading.value = true;
      hasError.value = false;

      final otp = otpDigits.join();
      if (otp.length != otpLength) {
        throw 'PleaseEnterCompleteOTP'.tr;
      }
      PatientAuthAPIService.verifyOtp(
        otp: otp,
        email: email,
        onSuccess: (response) {
          isLoading.value = false;
          _showSuccessMessage(response.data['message']);
          Get.offAllNamed(Routes.NEW_PASSWORD);
        },
        onError: (e) {
          isLoading.value = false;
          hasError.value = true;
          _handleError('Error'.tr, e.message);
        },
        onLoading: () {
          isLoading.value = true;
        },
      );

      Get.offAllNamed(Routes.NEW_PASSWORD);
    } catch (e) {
      hasError.value = true;
      _handleError('Error'.tr, e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _handleError(String title, String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      title: title,
      message: message,
    );
  }

  void _showSuccessMessage(String message) {
    CustomSnackBar.showCustomErrorSnackBar(
      message: message,
      color: Colors.green,
      title: 'Success'.tr,
    );
  }
}
