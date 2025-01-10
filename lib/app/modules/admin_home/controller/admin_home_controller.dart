import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  // Reactive variable for patient count
  RxInt patientsCount = 0.obs;
  RxInt doctorsCount = 0.obs;
  var selectedIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getPatientsCount();
    getDoctorsCount();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> getPatientsCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('patients').get();
      patientsCount.value = snapshot.size;
    } catch (e) {
      print(e);
    }
  }

  Future<void> getDoctorsCount() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('doctors').get();
      doctorsCount.value = snapshot.size;
    } catch (e) {
      print(e);
    }
  }
}
