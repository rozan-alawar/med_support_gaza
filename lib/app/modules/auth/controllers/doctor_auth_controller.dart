import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../../core/widgets/custom_snackbar_widget.dart';
import '../../../routes/app_pages.dart';
import '../../../data/models/doctor_model.dart';

class DoctorAuthController extends GetxController {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final DoctorService _doctorService = DoctorServicegit pull();

  // Observable variables
  final RxString selectedFilePath = ''.obs;
  final RxBool isUploading = false.obs;
  final RxBool isLogin = true.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isPasswordVisible2 = false.obs;
  final RxBool isLoading = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  final Rx<DoctorModel?> doctorData = Rx<DoctorModel?>(null);

  // OTP related variables
  final RxList<String> otpDigits = List.generate(4, (index) => '').obs;
  final RxInt timeRemaining = 15.obs;
  final RxBool canResend = false.obs;

  @override
  void onInit() {
    super.onInit();
    startTimer();
    // Listen to auth state changes
    currentUser.bindStream(_auth.authStateChanges());
    ever(currentUser, _handleAuthChanged);
  }

  void _handleAuthChanged(User? user) async {
    if (user != null) {
      try {
        final doctor = await _doctorService.getDoctorById(user.uid);
        if (doctor != null) {
          doctorData.value = doctor;
          // Update last seen
          await _doctorService.updateDoctorAvailability(user.uid, true);
        }
      } catch (e) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.toString(),
        );
      }
    } else {
      doctorData.value = null;
    }
  }

  // UI State Management
  void toggleView() => isLogin.value = !isLogin.value;
  void togglePasswordVisibility() => isPasswordVisible.value = !isPasswordVisible.value;
  void togglePasswordVisibility2() => isPasswordVisible2.value = !isPasswordVisible2.value;

  // File Upload Management
  Future<String?> uploadCertificate(String filePath) async {
    try {
      isUploading.value = true;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + filePath.split('/').last;
      final ref = _storage.ref().child('certificates/$fileName');
      final uploadTask = await ref.putFile(File(filePath));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'file_upload_error'.tr,
      );
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  Future<String?> uploadProfileImage(String filePath) async {
    try {
      isUploading.value = true;
      final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '_' + filePath.split('/').last;
      final ref = _storage.ref().child('profile_images/$fileName');
      final uploadTask = await ref.putFile(File(filePath));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'image_upload_error'.tr,
      );
      return null;
    } finally {
      isUploading.value = false;
    }
  }

  Future<void> pickFile(TextEditingController uploadFileController) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null) {
        selectedFilePath.value = result.files.single.path ?? '';
        uploadFileController.text = '${result.files.single.name}.${result.files.single.extension}';
        CustomSnackBar.showCustomSnackBar(
          title: 'file_selected'.tr,
          message: '${'file_selected_message'.tr}: ${result.files.single.name}',
        );
      }
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'file_error_message'.tr,
      );
    }
  }

  // Authentication Methods
  Future<void> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phoneNo,
    required String speciality,
    required String country,
    required String gender,
    String? profileImage,
    String? about,
    List<String>? expertise,
    List<String>? languages,
    int? experience,
  }) async {
    try {
      isLoading.value = true;

      // Create user with email and password
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String? certificateUrl;
      if (selectedFilePath.value.isNotEmpty) {
        certificateUrl = await uploadCertificate(selectedFilePath.value);
      }

      // Create working hours for all days
      final List<WorkingHours> defaultWorkingHours = List.generate(7, (index) {
        return WorkingHours(
          dayOfWeek: index + 1,
          startTime: '09:00',
          endTime: '17:00',
          isAvailable: true,
        );
      });

      // Create doctor model
      final doctor = DoctorModel(
        id: userCredential.user!.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        phoneNo: phoneNo,
        speciality: speciality,
        country: country,
        gender: gender,
        profileImage: profileImage,
        medicalCertificateUrl: certificateUrl ?? '',
        isVerified: false,
        about: about ?? '',
        expertise: expertise ?? [],
        languages: languages ?? ['Arabic', 'English'],
        experience: experience ?? 0,
        workingHours: defaultWorkingHours,
      );

      // Save to Firestore using DoctorService
      await _doctorService.createDoctor(doctor);

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'account_created_successfully'.tr,
      );

      Get.offAllNamed(Routes.DOCTOR_LOGIN);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      isLoading.value = true;
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Verify if the user is a doctor
      final doctor = await _doctorService.getDoctorById(userCredential.user!.uid);
      if (doctor == null) {
        throw 'not_a_doctor'.tr;
      }

      // Update doctor's online status and last seen
      await _doctorService.updateDoctorAvailability(userCredential.user!.uid, true);

      Get.offAllNamed(Routes.DOCTOR_HOME);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      if (currentUser.value != null) {
        await _doctorService.updateDoctorAvailability(currentUser.value!.uid, false);
      }
      await _auth.signOut();
      Get.offAllNamed(Routes.DOCTOR_LOGIN);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    }
  }

  Future<void> forgetPassword(String email) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      Get.toNamed(Routes.DOCTOR_VERIFICATION);
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resetPassword(String newPassword) async {
    try {
      isLoading.value = true;
      if (_auth.currentUser != null) {
        await _auth.currentUser!.updatePassword(newPassword);
        CustomSnackBar.showCustomSnackBar(
          title: 'Success'.tr,
          message: 'password_reset_successful'.tr,
        );
        Get.offAllNamed(Routes.DOCTOR_LOGIN);
      }
    } on FirebaseAuthException catch (e) {
      _handleFirebaseAuthError(e);
    } finally {
      isLoading.value = false;
    }
  }

  // Update doctor profile
  Future<void> updateProfile({
    String? firstName,
    String? lastName,
    String? phoneNo,
    String? about,
    List<String>? expertise,
    List<String>? languages,
    int? experience,
    List<WorkingHours>? workingHours,
    bool? isAvailable,
  }) async {
    try {
      isLoading.value = true;
      if (currentUser.value == null || doctorData.value == null) return;

      final updatedDoctor = doctorData.value!.copyWith(
        firstName: firstName,
        lastName: lastName,
        phoneNo: phoneNo,
        about: about,
        expertise: expertise,
        languages: languages,
        experience: experience,
        workingHours: workingHours,
        isAvailable: isAvailable,
      );

      await _doctorService.updateDoctor(updatedDoctor);

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'profile_updated_successfully'.tr,
      );
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // OTP Management
  void startTimer() {
    timeRemaining.value = 15;
    canResend.value = false;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeRemaining.value > 0) {
        timeRemaining.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  void setDigit(int index, String value) {
    if (value.length <= 1) {
      otpDigits[index] = value;
    }
  }

  void resendOTP() {
    otpDigits.assignAll(List.generate(4, (index) => ''));
    startTimer();
    forgetPassword(currentUser.value?.email ?? '');
  }

  Future<void> verifyOTP() async {
    try {
      isLoading.value = true;
      final otp = otpDigits.join();

      if (otp.length != 4) {
        throw 'invalid_otp_length'.tr;
      }

      // Add your OTP verification logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulate verification
      Get.offAllNamed(Routes.DOCTOR_RESET_PASSWORD);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Error Handling
  void _handleFirebaseAuthError(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'user-not-found':
        message = 'no_user_found'.tr;
        break;
      case 'wrong-password':
        message = 'wrong_password'.tr;
        break;
      case 'email-already-in-use':
        message = 'email_already_in_use'.tr;
        break;
      case 'invalid-email':
        message = 'invalid_email'.tr;
        break;
      case 'weak-password':
        message = 'weak_password'.tr;
        break;
      case 'operation-not-allowed':
        message = 'operation_not_allowed'.tr;
        break;
      case 'too-many-requests':
        message = 'too_many_requests'.tr;
        break;
      default:
        message = e.message ?? 'unknown_error'.tr;
    }
    CustomSnackBar.showCustomErrorSnackBar(
      title: 'Error'.tr,
      message: message,
    );
  }

  @override
  void onClose() {
    if (currentUser.value != null) {
      _doctorService.updateDoctorAvailability(currentUser.value!.uid, false);
    }
    super.onClose();
  }
}