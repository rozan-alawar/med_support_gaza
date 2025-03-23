import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/api_services/admin_home_api.dart';
import 'package:med_support_gaza/app/data/models/auth_response_model.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_content_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class AdminHomeController extends GetxController {
  RxInt patientsCount = 0.obs;
  RxInt doctorsCount = 0.obs;
  var selectedIndex = 0.obs;

  final searchQuery = ''.obs;
  final selectedTab = 0.obs;

  final RxBool isLoading = true.obs;
  RxList<PatientModel> patients = <PatientModel>[].obs;
  RxList<Doctor> doctors = <Doctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    getDoctors();
    getPatients();
    ContentController(). loadContent();

  }

  // Filter Methods
  void onSearchChanged(String query) {
    searchQuery.value = query.toLowerCase();
  }

  void setSelectedTab(int index) {
    selectedTab.value = index;
  }


  void changeTab(int index) {
    selectedIndex.value = index;
  }

  String getPageTitle() {
    switch (selectedIndex.value) {
      case 0:
        return 'Dashboard'.tr;
      case 1:
        return 'userManagment'.tr;
      case 2:
        return 'contentManagment'.tr;
      case 3:
        return 'serviceManagment'.tr;
      default:
        return '';
    }
  }

  //------------------------ GET PATIENTS -----------------------------
  void getPatients() {
    AdminHomeAPIService.getPatients(
      onSuccess: (response) {
        isLoading.value = false;
        List<PatientModel> patientsList = [];
        for (var item in response.data['patients']) {
          patientsList.add(PatientModel.fromJson(item));
        }
        patients.value = patientsList;
        patientsCount.value = patientsList.length;
      },
      onError: (e) {
        isLoading.value = false;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

//------------------------ GET DOCTORS -----------------------------
  void getDoctors() {
    AdminHomeAPIService.getDoctors(
      onSuccess: (response) {
        isLoading.value = false;
        List<Doctor> doctorsList = [];
        for (var item in response.data['doctors']) {
          doctorsList.add(Doctor.fromJson(item));
        }
        doctors.value = doctorsList;
        doctorsCount.value = doctorsList.length;

      },
      onError: (e) {
        isLoading.value = false;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

//------------------------ DELETE PATIENT -----------------------------
  void deletePatient(String patientId) {
    AdminHomeAPIService.deletePatient(
      patientId: patientId,
      onSuccess: (response) {
        isLoading.value = false;
        _showSuccessMessage(response.data['message']);
        // Refresh patients list after deletion
        getPatients();
      },
      onError: (e) {
        isLoading.value = false;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
  }

  //------------------------ SEND EMAIL TO DOCTOR -----------------------------

  void sendEmailToDoctor(String doctorEmail) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: doctorEmail,
      queryParameters: {
        'subject': 'Important: MedSupport Gaza Consultation',
        'body': 'Dear Doctor,\n\nWe would like to discuss an important matter regarding our platform.\n\nBest regards,\nMedSupport Gaza Team'
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Get.snackbar('Error', 'Could not open email app');
    }
  }

//------------------------ DELETE DOCTOR -----------------------------
  void deleteDoctor(String doctorId) {
    AdminHomeAPIService.deleteDoctor(
      doctorId: doctorId,
      onSuccess: (response) {
        isLoading.value = false;
        _showSuccessMessage(response.data['message']);
        // Refresh doctors list after deletion
        getDoctors();
      },
      onError: (e) {
        isLoading.value = false;
        _handleError('Error'.tr, e.message);
      },
      onLoading: () {
        isLoading.value = true;
      },
    );
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
