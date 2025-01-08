import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/modules/appointment_booking/controllers/appointment_service.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';

class HomeController extends GetxController {
  // Navigation state
  final RxInt currentIndex = 0.obs;

  // User state
  final RxString userName = ''.obs;
  final Rx<PatientModel?> currentUser = Rx<PatientModel?>(null);

  // Appointments state
  final RxList<AppointmentModel> appointments = <AppointmentModel>[].obs;
  final RxBool isLoading = false.obs;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    setupAppointmentsListener();
  }

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
    update();
  }


  // Appointments management
  void setupAppointmentsListener() {
    final user = _auth.currentUser;
    if (user == null) return;

    _firestore
        .collection('appointments')
        .where('userId', isEqualTo: user.uid)
        .where('status', isEqualTo: 'upcoming')
        .orderBy('date', descending: false)
        .snapshots()
        .listen(
          (snapshot) {
        final List<AppointmentModel> newAppointments = [];
        for (var doc in snapshot.docs) {
          try {
            newAppointments.add(AppointmentModel.fromJson(doc.data()));
          } catch (e) {
            print('Error parsing appointment: $e');
          }
        }
        appointments.value = newAppointments;
      },
      onError: (error) {
        print('Error listening to appointments: $error');
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: 'Failed to load appointments'.tr,
        );
      },
    );
  }
// User Data Management
  Future<void> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.AUTH);
        return;
      }

      final docSnapshot = await _firestore
          .collection('patients')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        currentUser.value = PatientModel.fromJson(docSnapshot.data()!);
        userName.value = "${currentUser.value?.firstName ?? ''} ${currentUser.value?.lastName ?? ''}";
      } else {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'Error'.tr,
          message: 'User data not found'.tr,
        );
      }
    } catch (e) {
      print('Error loading user data: $e');
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to load user data'.tr,
      );
    }
  }

  // Appointments Management
  Future<void> loadAppointments() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user == null) return;

      // Query without complex ordering
      final QuerySnapshot snapshot = await _firestore
          .collection('appointments')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'upcoming')
          .get();

      // Convert and sort appointments locally
      final List<AppointmentModel> loadedAppointments = snapshot.docs
          .map((doc) => AppointmentModel.fromJson({
        ...doc.data() as Map<String, dynamic>,
        'id': doc.id,
      }))
          .toList();

      // Sort by date and time
      loadedAppointments.sort((a, b) {
        // First compare by date
        int dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;

        // If dates are equal, compare by time
        return a.time.compareTo(b.time);
      });

      appointments.value = loadedAppointments;
    } catch (e) {
      print('Error loading appointments: $e');
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to load appointments'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadUserData(),
        loadAppointments(),
      ]);
    } catch (e) {
      print('Error refreshing data: $e');
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to refresh data'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> cancelAppointment(String appointmentId) async {
    try {
      isLoading.value = true;

      await _firestore
          .collection('appointments')
          .doc(appointmentId)
          .update({'status': 'cancelled'});

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Appointment cancelled successfully'.tr,
      );

      // Refresh appointments
      await loadAppointments();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to cancel appointment'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Profile management
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore
          .collection('patients')
          .doc(user.uid)
          .update(data);

      await loadUserData(); // Reload user data

      CustomSnackBar.showCustomSnackBar(
        title: 'Success'.tr,
        message: 'Profile updated successfully'.tr,
      );
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to update profile'.tr,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/auth');
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'Error'.tr,
        message: 'Failed to sign out'.tr,
      );
    }
  }

  @override
  void onClose() {
    // Clean up any controllers or streams if needed
    super.onClose();
  }
}