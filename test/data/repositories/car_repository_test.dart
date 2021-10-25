import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/core/network/network.dart';
import 'package:clean_teste/data/datasources/car_local_datasource.dart';
import 'package:clean_teste/data/datasources/car_remote_datasource.dart';
import 'package:clean_teste/data/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_model_mock.dart';

class CarRemoteDataSourceMock extends Mock implements CarRemoteDataSource {}

class CarLocalDataSourceMock extends Mock implements CarLocalDataSource {}

class NetworkMock extends Mock implements Network {}

main() {
  late CarRepositoryImpl repository;
  late CarRemoteDataSourceMock remoteDataSource;
  late CarLocalDataSourceMock localDataSource;
  late NetworkMock network;

  setUp(() {
    remoteDataSource = CarRemoteDataSourceMock();
    localDataSource = CarLocalDataSourceMock();
    network = NetworkMock();
    repository = CarRepositoryImpl(remoteDataSource, localDataSource, network);
  });

  void runTestsOnline(Function body) {
    group('Online', () {
      setUp(() {
        when(() => network.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('Offline', () {
      setUp(() {
        when(() => network.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('CarModel', () {
    test('Deve retornar se o celular está conectado', () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getCarById(any())).thenAnswer((_) async => carModel);

      repository.getCarById(1);

      verify(() => network.isConnected);
    });

    test('Deve retornar se o celular está desconectado', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);
      when(() => remoteDataSource.getCarById(any())).thenAnswer((_) async => carModel);

      repository.getCarById(1);

      verify(() => network.isConnected);
    });

    runTestsOnline(() {
      test('Deve retornar um CarModel quando a API for chamada', () async {
        when(() => remoteDataSource.getCarById(any())).thenAnswer((_) async => carModel);
        when(() => localDataSource.getCarById(any())).thenAnswer((_) => carModel);

        final result = await repository.getCarById(1);

        verify(() => remoteDataSource.getCarById(1)).called(1);
        verify(() => localDataSource.getCarById(1)).called(1);
        expect(result, Right(carModel));
      });
    });

    runTestsOffline(() {
      test('Deve retornar o último CarModel salvo no cache', () async {
        when(() => remoteDataSource.getCarById(any())).thenAnswer((_) async => carModel);
        when(() => localDataSource.getCarById(any())).thenAnswer((_) => carModel);

        final result = await repository.getCarById(1);

        expect(result, Right(carModel));
        verify(() => localDataSource.getCarById(1)).called(1);
      });

      test('Deve retornar um CacheError quando não conseguir recuperar o CarModel do cache', () async {
        when(() => remoteDataSource.getCarById(any())).thenAnswer((_) async => carModel);
        when(() => localDataSource.getCarById(any())).thenThrow(const CacheError('Falha ao recuperar Cache'));

        final result = await repository.getCarById(1);

        expect(result, const Left(CacheError('Falha ao recuperar Cache')));
        verify(() => localDataSource.getCarById(1)).called(1);
      });
    });
  });

  group('List<CarModel>', () {
    test('Deve retornar se o celular está conectado', () async {
      when(() => network.isConnected).thenAnswer((_) async => true);
      when(() => remoteDataSource.getCars()).thenAnswer((_) async => carListModel);
      when(() => localDataSource.setCars(any())).thenAnswer((_) => Future.value());

      repository.getCars();

      verify(() => network.isConnected);
    });

    test('Deve retornar se o celular está desconectado', () async {
      when(() => network.isConnected).thenAnswer((_) async => false);

      repository.getCars();

      verify(() => network.isConnected);
    });

    runTestsOnline(() {
      //rodar todo o teste pra funcionar
      test('Deve retornar uma List<CarModel> quando a API for chamada', () async {
        when(() => remoteDataSource.getCars()).thenAnswer((_) async => carListModel);
        when(() => localDataSource.getCars()).thenAnswer((_) => carListModel);
        when(() => localDataSource.setCars(any())).thenAnswer((_) => Future.value());

        final result = await repository.getCars();

        verify(() => localDataSource.getCars()).called(1);
        verify(() => remoteDataSource.getCars()).called(1);
        expect(result, Right(carListModel));
      });

      test('Deve salvar a List<CarModel> no cache quando retonar dados da API', () async {
        when(() => remoteDataSource.getCars()).thenAnswer((_) async => carListModel);
        when(() => localDataSource.getCars()).thenAnswer((_) => carListModel);
        when(() => localDataSource.setCars(any())).thenAnswer((_) => Future.value());

        await repository.getCars();

        verify(() => localDataSource.getCars()).called(1);
        verify(() {
          remoteDataSource.getCars().then((cars) {
            verify(() => localDataSource.setCars(cars)).called(1);
          });
        }).called(1);
      });
    });

    runTestsOffline(() {
      test('Deve retornar List<CarModel> salva no cache', () async {
        when(() => localDataSource.getCars()).thenAnswer((_) => carListModel);

        final result = await repository.getCars();

        expect(result, Right(carListModel));
        verify(() => localDataSource.getCars()).called(1);
        verifyZeroInteractions(remoteDataSource);
      });

      test('Deve retornar um CacheError quando não conseguir recuperar a List<CarModel> do cache', () async {
        when(() => localDataSource.getCars()).thenThrow(const CacheError('Falha ao recuperar Cache'));

        final result = await repository.getCars();

        expect(result, const Left(CacheError('Falha ao recuperar Cache')));
        verify(() => localDataSource.getCars()).called(1);
      });
    });
  });
}
