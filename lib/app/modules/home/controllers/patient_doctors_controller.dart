import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/api_services/patient_home_api.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/data/models/get_doctors_response.dart';

class PatientDoctorsController extends GetxController {
  final searchController = TextEditingController();
  final RxList<Doctor> doctors = <Doctor>[].obs;
  final RxList<String> specialties = <String>[].obs;
  final RxString selectedSpecialty = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<Doctor> topDoctors = <Doctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDoctors();
    fetchSpecialties();
  }
  //------------------------ GET DOCTORS -----------------------------

  void getDoctors() {
    HomeAPIService.getDoctors(
      onSuccess: (response) {
        isLoading.value = false;
        final List<dynamic> data = response.data['doctors'];
        // GetDoctorsResponse getDoctors =
        // GetDoctorsResponse.fromJson(response.data);
        doctors.value = data.map((e) => Doctor.fromJson(e)).toList();
        fetchTopDoctors();
        isLoading.value = false;
      },
      onError: (e) {
        isLoading.value = false;
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: e.message,
        );
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //
  // Future<void> fetchSpecialties() async {
  //   try {
  //     isLoading.value = true;
  //     final response = await DoctorAPIService.getSpecialties();
  //     specialties.value = response;
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }
  //
  // void onSearchChanged(String query) {
  //   if (query.isEmpty) {
  //     doctors.value = allDoctors;
  //     return;
  //   }
  //
  //   final searchLower = query.toLowerCase();
  //   final filtered = allDoctors.where((doctor) {
  //     return doctor.fullName.toLowerCase().contains(searchLower) ||
  //         doctor.speciality.toLowerCase().contains(searchLower);
  //   }).toList();
  //
  //   doctors.value = filtered;
  // }
  //
  // Future<void> refreshDoctors() async {
  //   await fetchDoctors();
  // } Future<void> fetchTopDoctors() async {
  //     isLoading.value = true;
  //     try {
  //       topDoctors.clear();
  //       for (int i = 0; i < doctors.length && i < 2; i++) {
  //         topDoctors.add(doctors[i]);
  //       }
  //     } finally {
  //       isLoading.value = false;
  //     }
  //   }

  Future<void> fetchTopDoctors() async {
    isLoading.value = true;
    try {
      topDoctors.clear();
      for (int i = 0; i < doctors.length && i < 2; i++) {
        topDoctors.add(doctors[i]);
      }
    } finally {
      isLoading.value = false;
    }
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
      getDoctors();
      return;
    }

    final filtered = doctors.where((Doctor doctor) {
      final searchLower = query.toLowerCase();
      return doctor.firstName!.toLowerCase().contains(searchLower) ||
          doctor.lastName!.toLowerCase().contains(searchLower) ||
          doctor.major!.toLowerCase().contains(searchLower);
    }).toList();

    doctors.value = filtered;
  }

  Future<void> refreshDoctors() async {
    getDoctors();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
