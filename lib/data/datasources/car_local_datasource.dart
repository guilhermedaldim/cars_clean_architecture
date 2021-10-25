import 'package:clean_teste/core/cache/cache_car_model.dart';
import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/data/models/car_model.dart';

abstract class CarLocalDataSource {
  static const carsBox = 'CARS';

  CarModel getCarById(int id);
  List<CarModel> getCars();

  Future<void> setCars(List<CarModel> cars);
}

class CarLocalDataSourceImpl implements CarLocalDataSource {
  final CacheCarModelImpl cacheImpl;

  CarLocalDataSourceImpl(this.cacheImpl);

  @override
  CarModel getCarById(id) {
    final cars = cacheImpl.read();

    if (cars.isNotEmpty) {
      return cars.firstWhere((car) => car.id == id);
    } else {
      throw const CacheError('Falha ao recuperar Cache');
    }
  }

  @override
  List<CarModel> getCars() {
    final cars = cacheImpl.read();

    if (cars.isNotEmpty) {
      return cars;
    } else {
      throw const CacheError('Falha ao recuperar Cache');
    }
  }

  @override
  Future<void> setCars(List<CarModel> cars) {
    return cacheImpl.write(cars);
  }
}
