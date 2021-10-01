import 'dart:convert';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks/car_mock.dart';
import '../../mocks/car_model_mock.dart';

main() {
  group('List<CarModel>', () {
    test('Deve retornar uma subclasse de List<Car>', () {
      expect(carListModel, isA<List<CarEntity>>());
    });

    test('Deve retornar um Model de List<Car> válido', () {
      final data = json.decode(carListMock);
      final result = List<CarModel>.from(data.map((x) => CarModel.fromJson(x)));

      expect(result, carListModel);
    });
  });

  group('CarModel', () {
    test('Deve retornar uma subclasse de Car', () {
      expect(carModel, isA<CarEntity>());
    });

    test('Deve retornar um Model de Car válido', () {
      final data = json.decode(carMock);
      final result = CarModel.fromJson(data);

      expect(result, carModel);
    });
  });
}
