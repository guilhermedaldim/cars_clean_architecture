import 'dart:convert';
import 'dart:io';
import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/data/datasources/car_local_datasource.dart';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_model_mock.dart';

class GetStorageMock extends Mock implements GetStorage {}

main() {
  late CarLocalDataSourceImpl datasource;
  late GetStorageMock getStorage;

  setUp(() {
    getStorage = GetStorageMock();
    datasource = CarLocalDataSourceImpl(getStorage);
    registerFallbackValue<CarModel>(const CarModel(id: 1));
  });

  final data = json.decode(File('test/mocks/cars_cached_mock.json').readAsStringSync());
  List<String> list = [];
  for (var i in data) {
    list.add(json.encode(i));
  }

  group('CarModel', () {
    test('Deve retornar um CarModel do cache', () async {
      final tCarModel = CarModel.fromJson(json.decode(File('test/mocks/car_cached_mock.json').readAsStringSync()));

      when(() => getStorage.read(any())).thenReturn(list.map((map) => json.decode(map)).toList());

      final result = datasource.getCar(1);

      verify(() => getStorage.read(CarLocalDataSource.cacheCars));
      expect(result, equals(tCarModel));
    });

    test('Deve retornar um CacheError para valores inválidos', () async {
      when(() => getStorage.read(any())).thenReturn(null);

      final result = datasource.getCar;

      expect(() => result(1), throwsA(const CacheError('Falha ao recuperar Cache')));
    });
  });

  group('List<CarModel>', () {
    test('Deve retornar uma List<CarModel> do cache', () async {
      List<CarModel> tCarModelList = List<CarModel>.from(list.map((car) => CarModel.fromJson(json.decode(car))));

      when(() => getStorage.read(any())).thenReturn(list.map((map) => json.decode(map)).toList());

      final result = datasource.getCars();

      verify(() => getStorage.read(CarLocalDataSource.cacheCars));
      expect(result, equals(tCarModelList));
    });

    test('Deve retornar um CacheError para valores inválidos', () async {
      when(() => getStorage.read(any())).thenReturn(null);

      final result = datasource.getCars;

      expect(() => result(), throwsA(const CacheError('Falha ao recuperar Cache')));
    });

    test('Deve salvar uma List<CarModel> no cache', () async {
      when(() => getStorage.write(CarLocalDataSource.cacheCars, any())).thenAnswer((_) async => Future.value());

      datasource.setCars(carListModel);

      verify(() => getStorage.write(CarLocalDataSource.cacheCars, carListModel.map((car) => car.toJson()).toList()));
    });
  });
}
