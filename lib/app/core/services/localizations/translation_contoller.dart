import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../cache_helper.dart';

class TranslationController extends GetxController {
  static Locale initalLang = CacheHelper.getData(key: 'lang') == null
      ? Get.deviceLocale!
      : Locale(CacheHelper.getData(key: 'lang'));

  static void changeLang(String langCode) {
    CacheHelper.saveData(key: 'lang', value: langCode);
    Locale locale = Locale(langCode);
    Get.updateLocale(locale);
  }
}
