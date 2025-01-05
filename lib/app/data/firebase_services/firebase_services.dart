
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
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
}

// 3. Enhanced Auth Controller (lib/app/controllers/auth_controller.dart)


// 4. Auth Binding (lib/app/bindings/auth_binding.dart)
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirebaseService>(() => FirebaseService());
    Get.lazyPut<AuthController>(() => AuthController());
  }
}