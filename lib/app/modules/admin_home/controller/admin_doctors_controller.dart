import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../../data/models/doctor_model.dart';

class AdminDoctorsController extends GetxController {
  var doctors = <DoctorModel>[].obs;
  final isTestMode = true;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    if (isTestMode) {
      loadDummyDoctors();
    } else {
      fetchUnapprovedDoctors();
    }
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
      loadDummyDoctors();
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
  List<WorkingHours> generateDefaultWorkingHours() {
    return List.generate(7, (index) => WorkingHours(
      dayOfWeek: index + 1,
      startTime: '09:00',
      endTime: '17:00',
      isAvailable: true,
    ));
  }

  void loadDummyDoctors() {
    final defaultWorkingHours = generateDefaultWorkingHours();

    doctors.value = [
      DoctorModel(
        id: '1',
        firstName: 'Ahmed',
        lastName: 'Mohamed',
        email: 'ahmed.mohamed@example.com',
        phoneNo: '+970 59-123-4567',
        speciality: 'Cardiology',
        country: 'Palestine',
        gender: 'Male',
        profileImage: 'https://example.com/profile1.jpg',
        medicalCertificateUrl: 'https://example.com/cert1.pdf',
        rating: 4.8,
        experience: 10,
        languages: ['Arabic', 'English', 'French'],
        isVerified: true,
        workingHours: defaultWorkingHours,
        about: 'Experienced cardiologist with focus on preventive care and heart disease management.',
        expertise: ['Interventional Cardiology', 'Echocardiography', 'Nuclear Cardiology'],
        isApproved: false,
        isOnline: true,
        isAvailable: true,
        createdAt: DateTime.now().subtract(Duration(days: 30)),
        lastSeen: DateTime.now().subtract(Duration(minutes: 5)),
      ),
      DoctorModel(
        id: '2',
        firstName: 'Sarah',
        lastName: 'Ibrahim',
        email: 'sarah.ibrahim@example.com',
        phoneNo: '+970 59-234-5678',
        speciality: 'Pediatrics',
        country: 'Palestine',
        gender: 'Female',
        profileImage: 'https://example.com/profile2.jpg',
        medicalCertificateUrl: 'https://example.com/cert2.pdf',
        rating: 4.9,
        experience: 8,
        languages: ['Arabic', 'English'],
        isVerified: true,
        workingHours: defaultWorkingHours,
        about: 'Dedicated pediatrician specializing in newborn care and childhood development.',
        expertise: ['Newborn Care', 'Vaccination', 'Child Development'],
        isApproved: false,
        isOnline: false,
        isAvailable: true,
        createdAt: DateTime.now().subtract(Duration(days: 45)),
        lastSeen: DateTime.now().subtract(Duration(hours: 2)),
      ),
      DoctorModel(
        id: '3',
        firstName: 'Mahmoud',
        lastName: 'Ali',
        email: 'mahmoud.ali@example.com',
        phoneNo: '+970 59-345-6789',
        speciality: 'Neurology',
        country: 'Palestine',
        gender: 'Male',
        profileImage: 'https://example.com/profile3.jpg',
        medicalCertificateUrl: 'https://example.com/cert3.pdf',
        rating: 4.7,
        experience: 12,
        languages: ['Arabic', 'English', 'German'],
        isVerified: true,
        workingHours: defaultWorkingHours,
        about: 'Neurologist specializing in stroke prevention and treatment.',
        expertise: ['Stroke Treatment', 'Epilepsy', 'Multiple Sclerosis'],
        isApproved: false,
        isOnline: true,
        isAvailable: false,
        createdAt: DateTime.now().subtract(Duration(days: 60)),
        lastSeen: DateTime.now().subtract(Duration(minutes: 15)),
      ),
      DoctorModel(
        id: '4',
        firstName: 'Fatima',
        lastName: 'Hassan',
        email: 'fatima.hassan@example.com',
        phoneNo: '+970 59-456-7890',
        speciality: 'Dermatology',
        country: 'Palestine',
        gender: 'Female',
        profileImage: 'https://example.com/profile4.jpg',
        medicalCertificateUrl: 'https://example.com/cert4.pdf',
        rating: 4.6,
        experience: 7,
        languages: ['Arabic', 'English', 'Turkish'],
        isVerified: true,
        workingHours: defaultWorkingHours,
        about: 'Dermatologist focusing on skin cancer prevention and cosmetic procedures.',
        expertise: ['Skin Cancer', 'Cosmetic Dermatology', 'Laser Treatment'],
        isApproved: false,
        isOnline: false,
        isAvailable: true,
        createdAt: DateTime.now().subtract(Duration(days: 20)),
        lastSeen: DateTime.now().subtract(Duration(hours: 1)),
      ),
      DoctorModel(
        id: '5',
        firstName: 'Omar',
        lastName: 'Khalil',
        email: 'omar.khalil@example.com',
        phoneNo: '+970 59-567-8901',
        speciality: 'Orthopedics',
        country: 'Palestine',
        gender: 'Male',
        profileImage: 'https://example.com/profile5.jpg',
        medicalCertificateUrl: 'https://example.com/cert5.pdf',
        rating: 4.9,
        experience: 15,
        languages: ['Arabic', 'English'],
        isVerified: true,
        workingHours: defaultWorkingHours,
        about: 'Orthopedic surgeon specializing in sports injuries and joint replacement.',
        expertise: ['Sports Medicine', 'Joint Replacement', 'Trauma Surgery'],
        isApproved: false,
        isOnline: true,
        isAvailable: true,
        createdAt: DateTime.now().subtract(Duration(days: 90)),
        lastSeen: DateTime.now(),
      ),
    ];
  }

}
