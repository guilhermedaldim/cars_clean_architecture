import 'package:clean_teste/core/cache/cache_car_model.dart';
import 'package:clean_teste/core/network/network.dart';
import 'package:clean_teste/data/datasources/car_local_datasource.dart';
import 'package:clean_teste/data/datasources/car_remote_datasource.dart';
import 'package:clean_teste/data/repositories/car_repository.dart';
import 'package:clean_teste/domain/repositories/car_repository.dart';
import 'package:clean_teste/domain/usecases/car_usecase.dart';
import 'package:clean_teste/presentation/controllers/detail_controller.dart';
import 'package:clean_teste/presentation/controllers/home_controller.dart';
import 'package:clean_teste/presentation/controllers/theme_controller.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

class AppBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(Client());
    Get.put(DataConnectionChecker());
    Get.put<CacheCarModelImpl>(CacheCarModelImpl());
    Get.put<Network>(NetworkImpl(Get.find<DataConnectionChecker>()));
    Get.put<CarRemoteDataSource>(CarRemoteDataSourceImpl(Get.find<Client>()));
    Get.put<CarLocalDataSource>(CarLocalDataSourceImpl(Get.find<CacheCarModelImpl>()));
    Get.put<CarRepository>(CarRepositoryImpl(Get.find<CarRemoteDataSource>(), Get.find<CarLocalDataSource>(), Get.find<Network>()));

    Get.lazyPut(() {
      Get.put<GetCars>(GetCars(Get.find<CarRepository>()));
      Get.put<ThemeController>(ThemeController());
      return HomeController();
    }, fenix: true);

    Get.lazyPut(() {
      Get.put<GetCarById>(GetCarById(Get.find<CarRepository>()));
      return DetailController();
    }, fenix: true);
  }
}
