import 'package:get/get.dart';

class DoctorHomeController extends GetxController {
  final RxInt currentIndex = 0.obs;

  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
  }


  var unreadMessages = 6.obs;
}
