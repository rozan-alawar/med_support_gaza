
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';
import 'package:med_support_gaza/app/modules/auth/controllers/auth_controller.dart';

class FirebaseService extends GetxService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Authentication Stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up
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
        // Create patient document in Firestore
        await _firestore
            .collection('patients')
            .doc(userCredential.user!.uid)
            .set(patient.copyWith(id: userCredential.user!.uid).toJson());
      }

      return userCredential;
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign In
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e.toString();
    }
  }

  // Password Reset
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e.toString();
    }
  }

  // Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Get Patient Data
  Future<PatientModel?> getPatientData(String uid) async {
    try {
      final doc = await _firestore.collection('patients').doc(uid).get();
      if (doc.exists) {
        return PatientModel.fromJson(doc.data()!);
      }
      return null;
    } catch (e) {
      throw e.toString();
    }
  }

  // Add appointment to Firestore
  Future<void> saveAppointment(AppointmentModel appointment) async {
    try {
      await _firestore
          .collection('appointments')
          .doc(appointment.id)
          .set(appointment.toJson());
    } catch (e) {
      throw Exception('Failed to save appointment: $e');
    }
  }

  // Get all appointments for current user
  Stream<List<AppointmentModel>> getUserAppointments() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) return Stream.value([]);

    return _firestore
        .collection('appointments')
        .where('userId', isEqualTo: userId)
        .orderBy('date')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => AppointmentModel.fromJson(doc.data()))
        .toList());
  }
}
