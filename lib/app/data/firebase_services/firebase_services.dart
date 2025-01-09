// firebase_service.dart
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_collections.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/data/models/doctor_model.dart';
import 'package:med_support_gaza/app/modules/profile/controllers/doctor_profile_controller.dart';
import '../models/patient_model.dart';


class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication Streams
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;
  final Rxn<PatientModel> patientData = Rxn<PatientModel>();

  // Initialize and set up patient data stream
  Future<void> initPatientDataStream() async {
    if (currentUser != null) {
      // Listen to patient document changes
      _firestore
          .collection('patients')
          .doc(currentUser!.uid)
          .snapshots()
          .listen((doc) {
        if (doc.exists) {
          patientData.value = PatientModel.fromJson(doc.data()!);
        } else {
          patientData.value = null;
        }
      }, onError: (e) {
        print('Error in patient data stream: $e');
        patientData.value = null;
      });
    }
  }

  // Get patient name (used in your controller)
  String get patientName {
    return '${patientData.value?.firstName ?? ''} ${patientData.value?.lastName ?? ''}'.trim();
  }

  // Call this in your app initialization
  @override
  void onInit() {
    super.onInit();
    initPatientDataStream();
    // Listen to auth changes to update patient data
    authStateChanges.listen((user) {
      if (user != null) {
        initPatientDataStream();
      } else {
        patientData.value = null;
      }
    });
  }
  // In FirebaseService class
  Future<void> deleteOldProfileImage(String userId) async {
    try {
      // Get reference to the image file in storage
      final storageRef = _storage.ref().child('doctors/$userId/profile.jpg');

      // Check if file exists before trying to delete
      try {
        await storageRef.getDownloadURL();
        // If we get here, file exists, so delete it
        await storageRef.delete();
      } catch (e) {
        // File doesn't exist, ignore the error
        if (e is FirebaseException && e.code == 'object-not-found') {
          return;
        } else {
          throw e;
        }
      }
    } catch (e) {
      print('Error deleting old profile image: $e');
      throw 'Failed to delete old profile image';
    }
  }

  // Authentication Methods
  Future<UserCredential?> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required PatientModel patient,
  }) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        await _firestore
            .collection(FirebaseCollections.patients)
            .doc(userCredential.user!.uid)
            .set(patient.copyWith(id: userCredential.user!.uid).toJson());

        // Send email verification
        await userCredential.user!.sendEmailVerification();
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw 'Failed to send password reset email: $e';
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw 'Failed to sign out: $e';
    }
  }

  // Patient Methods
  Future<PatientModel?> getPatientData(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.patients)
          .doc(uid)
          .get();

      return doc.exists ? PatientModel.fromJson(doc.data()!) : null;
    } catch (e) {
      throw 'Failed to fetch patient data: $e';
    }
  }

  Stream<PatientModel?> patientDataStream(String uid) {
    return _firestore
        .collection(FirebaseCollections.patients)
        .doc(uid)
        .snapshots()
        .map((doc) => doc.exists ? PatientModel.fromJson(doc.data()!) : null);
  }

  Future<void> updatePatientData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.patients)
          .doc(uid)
          .update(data);
    } catch (e) {
      throw 'Failed to update patient data: $e';
    }
  }

  // Doctor Methods
  Future<DoctorModel?> getDoctorData(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.doctors)
          .doc(uid)
          .get();

      return doc.exists ? DoctorModel.fromJson(doc.data()!) : null;
    } catch (e) {
      throw 'Failed to fetch doctor data: $e';
    }
  }

  Stream<List<DoctorModel>> getAvailableDoctors(String specialty) {
    return _firestore
        .collection(FirebaseCollections.doctors)
        .where('specialty', isEqualTo: specialty)
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => DoctorModel.fromJson(doc.data()))
        .toList());
  }

  // Appointment Methods
  Future<void> saveAppointment(AppointmentModel appointment) async {
    try {
      final batch = _firestore.batch();

      // Save appointment
      final appointmentRef = _firestore
          .collection(FirebaseCollections.appointments)
          .doc(appointment.id);
      batch.set(appointmentRef, appointment.toJson());

      // Update doctor availability
      final doctorRef = _firestore
          .collection(FirebaseCollections.doctors)
          .doc(appointment.doctorId);
      batch.update(doctorRef, {
        'appointments': FieldValue.arrayUnion([appointment.id])
      });

      // Update patient appointments
      final patientRef = _firestore
          .collection(FirebaseCollections.patients)
          .doc(appointment.patientId);
      batch.update(patientRef, {
        'appointments': FieldValue.arrayUnion([appointment.id])
      });

      await batch.commit();
    } catch (e) {
      throw 'Failed to save appointment: $e';
    }
  }

  Stream<List<AppointmentModel>> getUserAppointments({
    required String userId,
    required bool isDoctor,
  }) {
    final field = isDoctor ? 'doctorId' : 'patientId';

    return _firestore
        .collection(FirebaseCollections.appointments)
        .where(field, isEqualTo: userId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList());
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      final batch = _firestore.batch();

      final appointmentRef = _firestore
          .collection(FirebaseCollections.appointments)
          .doc(appointmentId);

      batch.update(appointmentRef, {
        'status': 'cancelled',
        'cancelledAt': FieldValue.serverTimestamp(),
      });

      await batch.commit();
    } catch (e) {
      throw 'Failed to cancel appointment: $e';
    }
  }

  // Helper Methods
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found with this email';
      case 'wrong-password':
        return 'Wrong password provided';
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'weak-password':
        return 'Password is too weak';
      case 'invalid-email':
        return 'Invalid email address';
      default:
        return e.message ?? 'An authentication error occurred';
    }
  }
  Future<List<DoctorModel>> getDoctorsBySpecialty(String specialty) async {
    try {

          final querySnapshot = await _firestore
              .collection('doctors')
              .where('speciality', isEqualTo: specialty)
              .where('isAvailable', isEqualTo: true)
              .orderBy('firstName')
              .get();

          if (querySnapshot.docs.isEmpty) {
            return [];
          }

          return querySnapshot.docs.map((doc) {
            final data = doc.data();
            return DoctorModel(
              id: doc.id,
              firstName: data['firstName'] ?? '',
              lastName: data['lastName'] ?? '',
              email: data['email'] ?? '',
              phoneNo: data['phoneNo'] ?? '',
              speciality: data['speciality'] ?? '',
              country: data['country'] ?? '',
              profileImage: data['profileImage'],
              gender: data['gender'] ?? '',
              isOnline: data['isOnline'] ?? false,
              isAvailable: data['isAvailable'] ?? true,
              medicalCertificateUrl: data['medicalCertificateUrl'] ?? '',
              rating: (data['rating'] ?? 0.0).toDouble(),
              experience: data['experience'] ?? 0,
              languages: List<String>.from(data['languages'] ?? ['Arabic', 'English']),
              createdAt: (data['createdAt'] as Timestamp?)?.toDate(),
              lastSeen: (data['lastSeen'] as Timestamp?)?.toDate(),
              isVerified: data['isVerified'] ?? false,
              workingHours: (data['workingHours'] as List?)
                  ?.map((wh) => WorkingHours.fromJson(wh))
                  .toList() ?? [],
              about: data['about'] ?? '',
              expertise: List<String>.from(data['expertise'] ?? []),
            );
          }).toList();
        } catch (e) {
          print('Error fetching doctors by specialty: $e');
          return [];
        }
      }

  Future<String> uploadDoctorImage(String imagePath, String userId) async {
    try {
      // Create storage reference
      final storageRef = _storage.ref().child('doctors/$userId/profile.jpg');

      // Create file
      final file = File(imagePath);

      // Upload with metadata
      final uploadTask = await storageRef.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {
            'userId': userId,
            'uploadedAt': DateTime.now().toIso8601String(),
          },
        ),
      );

      // Get download URL
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      // Update doctor's profile with new image URL
      await updateDoctorData(userId, {'imageUrl': downloadUrl});

      return downloadUrl;
    } catch (e) {
      print('Error uploading doctor image: $e');
      throw 'Failed to upload image';
    }
  }

// Update doctor data in Firestore
  Future<void> updateDoctorData(String userId, Map<String, dynamic> data) async {
    try {
      // Get current doctor data
      final docRef = _firestore.collection('doctors').doc(userId);
      final docSnap = await docRef.get();

      if (docSnap.exists) {
        // Update only provided fields
        await docRef.update({
          ...data,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        // Create new doctor document if it doesn't exist
        await docRef.set({
          ...data,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print('Error updating doctor data: $e');
      throw 'Failed to update doctor data';
    }
  }
}
