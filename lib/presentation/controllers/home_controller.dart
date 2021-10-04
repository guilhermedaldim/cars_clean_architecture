import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:clean_teste/domain/helpers/loading_status.dart';
import 'package:clean_teste/domain/usecases/car_usecase.dart';
import 'package:clean_teste/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final _loadingStatus = LoadingStatus.completed.obs;
  final _cars = RxList(<CarEntity>[]);
  final _theme = Get.isDarkMode.obs;

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<CarEntity> get cars => _cars;
  bool get theme => _theme.value;

  @override
  void onInit() {
    getCars();
    super.onInit();
  }

  void onActionClick(int id) {
    Get.toNamed(Routes.detail, arguments: id);
  }

  void onChagedTheme() {
    if (_theme.value) {
      _theme.value = !_theme.value;
      Get.changeThemeMode(ThemeMode.light);
    } else {
      _theme.value = !_theme.value;
      Get.changeThemeMode(ThemeMode.dark);
    }
  }

  Future<void> getCars({bool showLoading = true, bool showError = true}) async {
    final getCars = Get.find<GetCars>();

    if (showLoading) {
      _loadingStatus.value = LoadingStatus.loading;
    }

    getCars.call().then((value) {
      value.fold((l) {
        _loadingStatus.value = LoadingStatus.error;

        if (showError) {
          Get.rawSnackbar(message: l.message);
        }
      }, (r) {
        _loadingStatus.value = LoadingStatus.completed;
        _cars.value = r;
      });
    });
  }
}
