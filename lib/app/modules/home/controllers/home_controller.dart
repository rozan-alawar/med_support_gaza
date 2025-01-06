import 'package:get/get.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final RxInt currentIndex = 3.obs;


  void changeBottomNavIndex(int index) {
    currentIndex.value = index;
    update();

  }
}