import 'package:clean_teste/data/datasources/car_local_datasource.dart';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class CacheCarModel {
  Future<void> initialize();
  Future<void> open();
  Future<void> write(List<CarModel> carModel);
  List<CarModel> read();
  ValueListenable<Box<CarModel>> listenable();
  void registerAdapter();
}

class CacheCarModelImpl implements CacheCarModel {
  @override
  Future<void> initialize() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> open() async {
    if (!Hive.isBoxOpen(CarLocalDataSource.carsBox)) {
      await Hive.openBox<CarModel>(CarLocalDataSource.carsBox);
    }
  }

  @override
  Future<void> write(List<CarModel> cars) async {
    final box = Hive.box<CarModel>(CarLocalDataSource.carsBox);
    await box.clear();
    await box.addAll(cars);
  }

  @override
  List<CarModel> read() {
    final box = Hive.box<CarModel>(CarLocalDataSource.carsBox);
    return box.values.toList();
  }

  @override
  ValueListenable<Box<CarModel>> listenable() {
    return Hive.box<CarModel>(CarLocalDataSource.carsBox).listenable();
  }

  @override
  void registerAdapter() {
    return Hive.registerAdapter<CarModel>(CarModelAdapter());
  }
}
