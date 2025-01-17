import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';

import '../../../routes/app_pages.dart';

class AdminUserManagementController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final doctors = <DoctorModel>[].obs;
  final patients = <PatientModel>[].obs;
  final searchQuery = ''.obs;
  final selectedTab = 0.obs;
  final isLoading = false.obs;
  final isTestMode = true;

  @override
  void onInit() {
    super.onInit();
    if (isTestMode) {
      loadDummyData();
    } else {
      // fetchUsers();
      loadDummyData();

    }
    ever(searchQuery, (_) => filterUsers());
  }

  // Filter Methods
  void onSearchChanged(String query) {
    searchQuery.value = query.toLowerCase();
    filterUsers();
  }

  void setSelectedTab(int index) {
    selectedTab.value = index;
  }

  // Filtered getters
  List<DoctorModel> get filteredDoctors {
    if (searchQuery.isEmpty) return doctors;
    return doctors.where((doctor) {
      final name = '${doctor.firstName} ${doctor.lastName}'.toLowerCase();
      final email = doctor.email.toLowerCase();
      final query = searchQuery.value;
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  List<PatientModel> get filteredPatients {
    if (searchQuery.isEmpty) return patients;
    return patients.where((patient) {
      final name = '${patient.firstName} ${patient.lastName}'.toLowerCase();
      final email = patient.email.toLowerCase();
      final query = searchQuery.value;
      return name.contains(query) || email.contains(query);
    }).toList();
  }

  void loadDummyData() {
    doctors.value = [
      DoctorModel(
        id: '1',
        firstName: 'Ameen',
        lastName: 'Mohamed',
        email: 'aminamin@gmail.com',
        phoneNo: '+970 59-123-4567',
        speciality: 'Cardiology',
        country: 'Palestine',
        gender: 'Male',
        profileImage: 'https://example.com/doctor1.jpg',
        medicalCertificateUrl: 'https://example.com/cert1.pdf',
        rating: 4.8,
        experience: 10,
        isApproved: false,
      ),
      DoctorModel(
        id: '2',
        firstName: 'Sarah',
        lastName: 'Ahmed',
        email: 'aminamin@gmail.com',
        phoneNo: '+970 59-234-5678',
        speciality: 'Pediatrics',
        country: 'Palestine',
        gender: 'Male',
        profileImage: 'https://example.com/doctor2.jpg',
        medicalCertificateUrl: 'https://example.com/cert2.pdf',
        rating: 4.9,
        experience: 8,
        isApproved: false,
      ),
    ];

    patients.value = [
      PatientModel(
        id: '1',
        firstName: 'Mohamed',
        lastName: 'Ahmed',
        email: 'mohammed@gmail.com',
        phoneNo: '+970 59-876-5432',
        age: '35',
        gender: 'Male',
        country: 'Palestine',
      ),
      PatientModel(
        id: '2',
        firstName: 'Fatema',
        lastName: 'Ali',
        email: 'fatima@gmail.com',
        phoneNo: '+970 59-765-4321',
        age: '28',
        gender: 'Female',
        country: 'Palestine',
      ),
    ];

    filterUsers();
  }
  //
  // Future<void> fetchUsers() async {
  //   try {
  //     isLoading.value = true;
  //
  //     // Fetch doctors
  //     final doctorsSnapshot = await _firestore.collection('doctors').get();
  //     doctors.value = doctorsSnapshot.docs
  //         .map((doc) => DoctorModel.fromJson(doc.data()))
  //         .toList();
  //
  //     // Fetch patients
  //     final patientsSnapshot = await _firestore.collection('patients').get();
  //     patients.value = patientsSnapshot.docs
  //         .map((doc) => PatientModel.fromJson(doc.data()))
  //         .toList();
  //
  //   } catch (e) {
  //     CustomSnackBar.showCustomErrorSnackBar(
  //       title: 'Error',
  //       message: 'Failed to fetch users: $e',
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  void filterUsers() {
  }

  Future<void> sendEmailToDoctor(String doctorId) async {
    try {
      final doctor = doctors.firstWhere((d) => d.id == doctorId);
      CustomSnackBar.showCustomSnackBar(
        title: 'Success',
        message: 'Email sent to ${doctor.email}',
      );
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to send email: $e',
      );
    }
  }

  Future<void> deleteUser(String userId, bool isDoctor) async {
    try {
      if (isTestMode) {
        if (isDoctor) {
          doctors.removeWhere((d) => d.id == userId);
        } else {
          patients.removeWhere((p) => p.id == userId);
        }
        return;
      }

      // final collection = isDoctor ? 'doctors' : 'patients';
      // await _firestore.collection(collection).doc(userId).delete();
      // await fetchUsers();

      CustomSnackBar.showCustomSnackBar(
        title: 'Success',
        message: 'User deleted successfully',
      );
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error',
        message: 'Failed to delete user: $e',
      );
    }
  }

  Future<void> refreshUsers() async {
    if (isTestMode) {
      loadDummyData();
    } else {
      // await fetchUsers();
      loadDummyData();

    }
  }
  void logout() async {
    try {
      await _auth.signOut();
      Get.offAllNamed(Routes.SPLASH);
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out: $e');
    }
  }
}
