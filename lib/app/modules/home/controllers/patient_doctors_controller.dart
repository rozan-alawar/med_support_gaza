import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';

class PatientDoctorsController extends GetxController {
  final searchController = TextEditingController();
  final RxList<DoctorModel> doctors = <DoctorModel>[].obs;
  final RxList<String> specialties = <String>[].obs;
  final RxString selectedSpecialty = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<DoctorModel> topDoctors = <DoctorModel>[].obs;


  @override
  void onInit() {
    super.onInit();
    fetchTopDoctors();
    fetchDoctors();
    fetchSpecialties();
  }

  Future<void> fetchTopDoctors() async {
    try {
      isLoading.value = true;
      // Implement API call
      await Future.delayed(Duration(seconds: 1)); // Mock delay
      topDoctors.value = [

    DoctorModel(
    id: '1',
    firstName: 'Ahmed',
    lastName: 'Mohammed',
    email: 'ahmed@example.com',
    phoneNo: '+970591234567',
    speciality: 'Cardiology',
    country: 'Palestine',
    gender: 'Male',
    rating: 4.9,
    experience: 15,
    medicalCertificateUrl: 'url',
    about: 'Experienced cardiologist with focus on preventive care',
    expertise: ['Heart Disease', 'Hypertension'],
    languages: ['Arabic', 'English'],
    isApproved: true,
    isVerified: true
    ),
        // Add more mock doctors
      ];
    } finally {
      isLoading.value = false;
    }
  }


  void fetchDoctors() {
    isLoading.value = true;

    doctors.value = [
      DoctorModel(
          id: '1',
          firstName: 'Ahmed',
          lastName: 'Mohammed',
          email: 'ahmed@example.com',
          phoneNo: '+970591234567',
          speciality: 'Cardiology',
          country: 'Palestine',
          gender: 'Male',
          rating: 4.9,
          experience: 15,
          medicalCertificateUrl: 'url',
          about: 'Experienced cardiologist with focus on preventive care',
          expertise: ['Heart Disease', 'Hypertension'],
          languages: ['Arabic', 'English'],
          isApproved: true,
          isVerified: true
      ),
      DoctorModel(
          id: '2',
          firstName: 'Sara',
          lastName: 'Ahmad',
          email: 'sara@example.com',
          phoneNo: '+970597654321',
          speciality: 'Pediatrics',
          country: 'Palestine',
          gender: 'Female',
          rating: 4.8,
          experience: 10,
          medicalCertificateUrl: 'url',
          about: 'Dedicated pediatrician focused on child development',
          expertise: ['Child Care', 'Vaccinations'],
          languages: ['Arabic', 'English', 'French'],
          isApproved: true,
          isVerified: true
      ),
    ];

    isLoading.value = false;
  }

  void fetchSpecialties() {
    specialties.value = [
      'Cardiology',
      'Pediatrics',
      'Neurology',
      'Dermatology',
      'Orthopedics'
    ];
  }

  void onSearchChanged(String query) {
    if (query.isEmpty) {
      fetchDoctors();
      return;
    }

    final filtered = doctors.where((doctor) {
      final searchLower = query.toLowerCase();
      return doctor.fullName.toLowerCase().contains(searchLower) ||
          doctor.speciality.toLowerCase().contains(searchLower);
    }).toList();

    doctors.value = filtered;
  }

  Future<void> refreshDoctors() async {
    fetchDoctors();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}