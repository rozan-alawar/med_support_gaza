import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final RxInt currentIndex = 3.obs;


  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
    update();
  }

}
