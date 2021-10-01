import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:clean_teste/domain/helpers/loading_status.dart';
import 'package:clean_teste/domain/usecases/car_usecase.dart';
import 'package:get/get.dart';

class DetailController extends GetxController {
  final _loadingStatus = LoadingStatus.completed.obs;
  late final _car = Rxn<CarEntity>();

  LoadingStatus get loadingStatus => _loadingStatus.value;
  CarEntity get car => _car.value!;

  @override
  void onInit() {
    getCarById(Get.arguments); //recebe o id por argumento na navegação
    super.onInit();
  }

  Future<void> getCarById(int id, {bool showLoading = true, bool showError = true}) async {
    final getCarById = Get.find<GetCarById>();

    if (showLoading) {
      _loadingStatus.value = LoadingStatus.loading;
    }

    getCarById.call(id).then((value) {
      value.fold((l) {
        _loadingStatus.value = LoadingStatus.error;

        if (showError) {
          Get.rawSnackbar(message: l.message);
        }
      }, (r) {
        _loadingStatus.value = LoadingStatus.completed;
        _car.value = r;
      });
    });
  }
}
