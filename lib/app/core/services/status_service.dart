import 'dart:io';
import 'package:get/get.dart';

class StatusService extends GetxService {
  RxBool _isOnline = false.obs;

  bool get isOnline => _isOnline.value;

  Future<void> toggleOnlineStatus() async {
    _isOnline.value = !_isOnline.value;
  }

  Future<void> setOnline() async {
    _isOnline.value = true;
  }

  Future<void> setOffline() async {
    _isOnline.value = false;
  }

  Future<void> checkStatus() async {
     print(
          '----------------------checkStatus------------------------');
    try {
      final response = await InternetAddress.lookup(
        'https://www.google.com/',
      );
      print(
          '---------------------------- response.isNotEmpty : ${response.isNotEmpty}------------------');
      if (response.isNotEmpty) {
        await setOnline();
      } else {
        await setOffline();
      }
    } on SocketException catch (e) {
      print('---------------------------- SocketException : $e------------------');
      await setOffline();

    }
  }
}
