import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/data/datasources/datasources.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_mock.dart';
import '../../mocks/car_model_mock.dart';

class ClientMock extends Mock implements Client {}

main() {
  late ClientMock client;
  late CarRemoteDataSourceImpl datasource;

  setUp(() {
    client = ClientMock();
    datasource = CarRemoteDataSourceImpl(client);
    registerFallbackValue<Uri>(Uri());
  });

  group('List<CarModel>', () {
    test('Deve retornar uma List<CarModel> quando a requisição for sucesso', () async {
      when(() => client.get(any())).thenAnswer((_) async => Response(carListMock, 200));

      final result = await datasource.getCars();
      expect(result, carListModel);
    });

    test('Deve retornar um HttpError quando a chamada não for um sucesso', () async {
      when(() => client.get(any())).thenAnswer((_) async => Response('Falha na requisição', 400));

      final result = datasource.getCars();
      expect(() => result, throwsA(const HttpError('Falha na requisição')));
    });
  });

  group('CarModel', () {
    test('Deve retornar um CarModel quando a requisição for sucesso', () async {
      when(() => client.get(any())).thenAnswer((_) async => Response(carMock, 200));

      final result = await datasource.getCarById(1);
      expect(result, carModel);
    });

    test('Deve retornar um HttpError quando a chamada não for um sucesso', () async {
      when(() => client.get(any())).thenAnswer((_) async => Response('Falha na requisição', 400));

      final result = datasource.getCarById(1);
      expect(() => result, throwsA(const HttpError('Falha na requisição')));
    });
  });
}
