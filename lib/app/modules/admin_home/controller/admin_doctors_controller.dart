import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/doctor_model.dart';

class AdminDoctorsController extends GetxController {
  var doctors = <DoctorModel>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUnapprovedDoctors();
  }

  void fetchUnapprovedDoctors() async {
    try {
      final querySnapshot = await _firestore
          .collection('doctors')
          .where('isApproved', isEqualTo: false)
          .get();

      doctors.value = querySnapshot.docs.map((doc) {
        return DoctorModel.fromJson(doc.data());
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch doctors: $e');
    }
  }

  void approveDoctor(String doctorId) async {
    try {
      print('Attempting to approve doctor with ID: $doctorId');
      if (doctorId.isEmpty) {
        throw Exception('Doctor ID is empty or null');
      }

      await _firestore.collection('doctors').doc(doctorId).update({
        'isApproved': true,
      });

      print('Successfully approved doctor with ID: $doctorId');
      fetchUnapprovedDoctors();
    } catch (e) {
      Get.snackbar('Error', 'Failed to approve doctor: $e');
      print('Error in approveDoctor: $e');
    }
  }

  void declineDoctor(String doctorId) async {
    try {
      print('Attempting to decline doctor with ID: $doctorId');
      if (doctorId.isEmpty) {
        throw Exception('Doctor ID is empty or null');
      }

      await _firestore.collection('doctors').doc(doctorId).delete();

      print('Successfully declined doctor with ID: $doctorId');
      fetchUnapprovedDoctors();
    } catch (e) {
      Get.snackbar('Error', 'Failed to decline doctor: $e');
      print('Error in declineDoctor: $e');
    }
  }
}
