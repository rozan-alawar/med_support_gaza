import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/api_services/admin_home_api.dart';
import 'package:med_support_gaza/app/data/models/doctor.dart';
import 'package:med_support_gaza/app/modules/admin_home/controller/admin_home_controller.dart';


class AdminDoctorsController extends GetxController {
  final RxBool isLoading = true.obs;
  RxList<Doctor> pendingDoctors = <Doctor>[].obs;

  @override
  void onInit() {
    super.onInit();
    getPendingDoctors();
  }

//------------------------ GET PENDING DOCTORS -----------------------------
  void getPendingDoctors() {
    AdminHomeAPIService.getPendingDoctors(
      onSuccess: (response) {
        isLoading.value = false;
        List<Doctor> pendingDoctorsList = [];
        for (var item in response.data['message']) {
          pendingDoctorsList.add(Doctor.fromJson(item));
        }
        pendingDoctors.value = pendingDoctorsList;
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
//------------------------ APPROVE DOCTOR -----------------------------
  void approveDoctor(String doctorId) {
    AdminHomeAPIService.approveDoctor(
      doctorId: doctorId,
      onSuccess: (response) {
        isLoading.value = false;
        _showSuccessMessage(response.data['message']);
        // Refresh pending doctors list after approval
        getPendingDoctors();
        // Also refresh approved doctors list
       AdminHomeController().getDoctors();
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

//------------------------ DECLINE DOCTOR -----------------------------
  void declineDoctor(String doctorId) {
    AdminHomeAPIService.declineDoctor(
      doctorId: doctorId,
      onSuccess: (response) {
        isLoading.value = false;
        _showSuccessMessage(response.data['message']);
        // Refresh pending doctors list after declining
        getPendingDoctors();
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
