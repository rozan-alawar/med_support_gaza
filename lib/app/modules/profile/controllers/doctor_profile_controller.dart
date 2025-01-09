
// doctor_profile_controller.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:med_support_gaza/app/core/widgets/custom_text_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import '../../../data/models/doctor_model.dart';

class DoctorProfileController extends GetxController {
  final FirebaseService _firebaseService = Get.find<FirebaseService>();
  final isLoading = false.obs;
  final Rx<DoctorModel?> doctorData = Rx<DoctorModel?>(null);

  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController phoneController;
  late TextEditingController experienceController;
  late TextEditingController aboutController;

  // Observable values
  final selectedGender = ''.obs;
  final selectedCountry = ''.obs;
  final selectedSpeciality = ''.obs;
  final selectedLanguages = <String>{}.obs;

  // Form key
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    initializeControllers();

    fetchDoctorData();
  }

  void initializeControllers() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    phoneController = TextEditingController();
    experienceController = TextEditingController();
    aboutController = TextEditingController();
  }

  void populateFields() {
    if (doctorData.value != null) {
      final doctor = doctorData.value!;
      firstNameController.text = doctor.firstName;
      lastNameController.text = doctor.lastName;
      phoneController.text = doctor.phoneNo;
      experienceController.text = doctor.experience.toString();
      aboutController.text = doctor.about;
      selectedGender.value = doctor.gender;
      selectedCountry.value = doctor.country;
      selectedSpeciality.value = doctor.speciality;
      selectedLanguages.value = Set<String>.from(doctor.languages);
    }
  }

  Future<void> fetchDoctorData() async {
    try {
      isLoading.value = true;
      final userId = _firebaseService.currentUser?.uid;
      if (userId != null) {
        doctorData.value = await _firebaseService.getDoctorData(userId);
        populateFields();
      }
    } catch (e) {
      print('Error fetching doctor data: $e');
      Get.snackbar(
        'Error',
        'Failed to load profile data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    try {
      isLoading.value = true;

      final userId = _firebaseService.currentUser?.uid;
      if (userId == null) throw 'User not logged in';

      final updatedData = {
        'firstName': firstNameController.text.trim(),
        'lastName': lastNameController.text.trim(),
        'phoneNo': phoneController.text.trim(),
        'gender': selectedGender.value,
        'country': selectedCountry.value,
        'speciality': selectedSpeciality.value,
        'experience': int.tryParse(experienceController.text) ?? 0,
        'about': aboutController.text.trim(),
        'languages': selectedLanguages.toList(),
        'updatedAt': DateTime.now(),
      };

      await _firebaseService.updateDoctorData(userId, updatedData);

      await fetchDoctorData(); // Refresh data

      Get.back(); // Return to profile page
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      print('Error updating profile: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        isLoading.value = true;
        final userId = _firebaseService.currentUser?.uid;
        if (userId == null) throw 'User not logged in';

        // Delete old image if exists
        if (doctorData.value?.profileImage != null) {
          await _firebaseService.deleteOldProfileImage(userId);
        }

        final imageUrl = await _firebaseService.uploadDoctorImage(
          image.path,
          userId,
        );

        await _firebaseService.updateDoctorData(userId, {
          'profileImage': imageUrl,
          'updatedAt': DateTime.now(),
        });

        await fetchDoctorData();

        Get.snackbar(
          'Success',
          'Profile image updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error updating profile image: $e');
      Get.snackbar(
        'Error',
        'Failed to update profile image',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  void changeLanguage() {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: CustomText('English'),
              onTap: () => _updateLanguage('en'),
            ),
            ListTile(
              title: CustomText('العربية'),
              onTap: () => _updateLanguage('ar'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateLanguage(String langCode) {
    Get.back();
    Get.updateLocale(Locale(langCode));
    // Update in preferences if needed
  }



  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void editProfile() {
    Get.toNamed('/edit-profile', arguments: doctorData.value);
  }


  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    experienceController.dispose();
    aboutController.dispose();
    super.onClose();
  }
}
