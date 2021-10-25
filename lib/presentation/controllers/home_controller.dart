import 'package:clean_teste/core/cache/cache_car_model.dart';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:clean_teste/domain/helpers/loading_status.dart';
import 'package:clean_teste/domain/usecases/car_usecase.dart';
import 'package:clean_teste/presentation/controllers/theme_controller.dart';
import 'package:clean_teste/routes/app_routes.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomeController extends GetxController {
  final _loadingStatus = LoadingStatus.completed.obs;
  final _cars = RxList(<CarEntity>[]);

  LoadingStatus get loadingStatus => _loadingStatus.value;
  List<CarEntity> get cars => _cars;

  @override
  void onInit() {
    getCars(showError: listenableBox().value.values.isNotEmpty);
    super.onInit();
  }

  void onActionClick(int id) {
    Get.toNamed(Routes.detail, arguments: id);
  }

  void onChagedTheme() {
    Get.put(ThemeController()).onChagedTheme();
  }

  ValueListenable<Box<CarModel>> listenableBox() {
    return CacheCarModelImpl().listenable();
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
        r.sort((a, b) => a.id.compareTo(b.id));
        _cars.value = r;
      });
    });
  }
}
