import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:get_storage/get_storage.dart';

abstract class CarLocalDataSource {
  static const cacheCars = 'CACHE_CARS';

  CarModel? getCar(int id);
  List<CarModel> getCars();

  Future<void> setCars(List<CarModel> cars);
}

class CarLocalDataSourceImpl implements CarLocalDataSource {
  final GetStorage getStorage;

  CarLocalDataSourceImpl(this.getStorage);

  @override
  CarModel? getCar(id) {
    final cache = getStorage.read(CarLocalDataSource.cacheCars);

    if (cache != null) {
      List<CarModel> cars = List<CarModel>.from(cache.map((car) => CarModel.fromJson(car)));
      for (var car in cars) {
        if (id == car.id) {
          return car;
        }
      }
    } else {
      throw const CacheError('Falha ao recuperar Cache');
    }
  }

  @override
  List<CarModel> getCars() {
    final cars = getStorage.read(CarLocalDataSource.cacheCars);

    if (cars != null) {
      return List<CarModel>.from(cars.map((car) => CarModel.fromJson(car)));
    } else {
      throw const CacheError('Falha ao recuperar Cache');
    }
  }

  @override
  Future<void> setCars(List<CarModel> cars) {
    return getStorage.write(CarLocalDataSource.cacheCars, cars.map((car) => car.toJson()).toList());
  }
}
