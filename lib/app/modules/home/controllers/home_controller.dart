import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:med_support_gaza/app/core/widgets/custom_snackbar_widget.dart';
import 'package:med_support_gaza/app/data/firebase_services/firebase_services.dart';
import 'package:med_support_gaza/app/data/models/%20appointment_model.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:med_support_gaza/app/data/models/patient_model.dart';

class HomeController extends GetxController {
  // Navigation state
  final RxInt currentIndex = 0.obs;

  // User state
  final RxString userName = ''.obs;
  final Rx<PatientModel?> currentUser = Rx<PatientModel?>(null);

  final FirebaseService _appointmentService = Get.find<FirebaseService>();
  final FirebaseService _authService = Get.find<FirebaseService>();

  final RxList<AppointmentModel> upcomingAppointments =
      <AppointmentModel>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _loadAppointments();
    loadUserData();
  }

  void _loadAppointments() {
    try {
      final userId = _authService.currentUser?.uid;
      if (userId == null) {
        error.value = 'No user logged in';
        return;
      }

      // Listen to upcoming appointments stream
      _appointmentService.getUpcomingAppointments(userId).listen(
        (appointments) {
          upcomingAppointments.value = appointments;
          isLoading.value = false;
        },
        onError: (err) {
          error.value = 'Error loading appointments: $err';
          isLoading.value = false;
        },
      );
      upcomingAppointments.sort((a, b) {
        // First compare by date
        int dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;

        // If dates are equal, compare by time
        return a.time.compareTo(b.time);
      });
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

  String getFormattedDate(DateTime date) {
    final now = DateTime.now();
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return 'Today';
    } else if (date.year == tomorrow.year &&
        date.month == tomorrow.month &&
        date.day == tomorrow.day) {
      return 'Tomorrow';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String getFormattedTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> cancelAppointment(String appointmentId) async {
    try {
      await _appointmentService.updateAppointmentStatus(
          appointmentId, 'cancelled');
    } catch (e) {
      error.value = 'Error cancelling appointment: $e';
    }
  }

// User Data Management
  Future<void> loadUserData() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        Get.offAllNamed(Routes.AUTH);
        return;
      }

      final docSnapshot =
          await _firestore.collection('patients').doc(user.uid).get();

      if (docSnapshot.exists) {
        currentUser.value = PatientModel.fromJson(docSnapshot.data()!);
        userName.value =
            "${currentUser.value?.firstName ?? ''} ${currentUser.value?.lastName ?? ''}";
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

  Future<void> refreshData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadUserData(),
      ]);
      _loadAppointments();
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

  // Profile management
  Future<void> updateProfile(Map<String, dynamic> data) async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('patients').doc(user.uid).update(data);

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
