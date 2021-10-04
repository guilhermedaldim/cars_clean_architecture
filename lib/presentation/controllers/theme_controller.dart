import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final _theme = Get.isDarkMode.obs;

  bool get theme => _theme.value;

  void onChagedTheme() {
    if (_theme.value) {
      _theme.value = !_theme.value;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      _theme.value = !_theme.value;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }
}
