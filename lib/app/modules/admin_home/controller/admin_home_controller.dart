import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminHomeController extends GetxController {
  // Reactive variable for patient count
  RxInt patientsCount = 0.obs;
  @override
  void onInit() {
    super.onInit();
    getPatientsCount();
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
}
