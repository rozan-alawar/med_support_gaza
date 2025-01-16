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
  String getPageTitle() {
    switch (selectedIndex.value) {
      case 0:
        return 'Dashboard'.tr;
      case 1:
        return 'userManagment'.tr;
      case 2:
        return 'contentManagment'.tr;
      case 3:
        return 'serviceManagment'.tr;
      default:
        return '';
    }
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
