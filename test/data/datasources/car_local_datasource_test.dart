import 'package:clean_teste/core/cache/cache_car_model.dart';
import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/data/datasources/car_local_datasource.dart';
import 'package:clean_teste/data/models/car_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_model_mock.dart';

class CacheMock extends Mock implements CacheCarModelImpl {}

main() {
  late CarLocalDataSourceImpl datasource;
  late CacheMock cache;

  setUp(() {
    cache = CacheMock();
    datasource = CarLocalDataSourceImpl(cache);
    registerFallbackValue(const CarModel(id: 1));
  });

  group('Initialize cache', () {
    test('Deve inicializar o Hive', () async {
      when(() => cache.initialize()).thenAnswer((_) => Future.value());

      await cache.initialize();

      verify(() => cache.initialize());
    });

    test('Deve abrir a caixa do Hive', () async {
      when(() => cache.open()).thenAnswer((_) => Future.value());

      await cache.open();

      verify(() => cache.open());
    });
  });

  group('CarModel', () {
    test('Deve retornar um CarModel do cache', () async {
      when(() => cache.read()).thenReturn(carListModel);

      final result = datasource.getCarById(1);

      verify(() => cache.read());
      expect(result, equals(carModel));
    });

    test('Deve retornar um CacheError para valores inválidos', () async {
      when(() => cache.read()).thenReturn([]);

      final result = datasource.getCarById;

      expect(() => result(1), throwsA(const CacheError('Falha ao recuperar Cache')));
    });
  });

  group('List<CarModel>', () {
    test('Deve retornar uma List<CarModel> do cache', () async {
      when(() => cache.read()).thenReturn(carListModel);

      final result = datasource.getCars();

      verify(() => cache.read());
      expect(result, equals(carListModel));
    });

    test('Deve retornar um CacheError para valores inválidos', () async {
      when(() => cache.read()).thenReturn([]);

      final result = datasource.getCars;

      expect(() => result(), throwsA(const CacheError('Falha ao recuperar Cache')));
    });

    test('Deve salvar um CarModel de retorno da API no cache', () async {
      when(() => cache.write(any())).thenAnswer((_) async => Future.value());

      datasource.setCars(carListModel);

      verify(() => cache.write(carListModel));
    });
  });
}
