import 'package:get/get.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class DoctorHomeController extends GetxController {

  final RxInt currentIndex = 0.obs;

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
  }
}