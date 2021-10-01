import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/domain/repositories/repositories.dart';
import 'package:clean_teste/domain/usecases/usecases.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_entity_mock.dart';

class CarRepositoryMock extends Mock implements CarRepository {}

main() {
  late CarRepository repository;
  late GetCars getCars;
  late GetCarById getCar;

  setUp(() {
    repository = CarRepositoryMock();
    getCars = GetCars(repository);
    getCar = GetCarById(repository);
  });

  group('List<CarEntity>', () {
    test('Deve retornar uma List<CarEntity>', () async {
      // arrange
      when(() => repository.getCars()).thenAnswer((_) async => Right(carListEntity));

      //act
      final result = await getCars();

      //assert
      expect(result, equals(Right(carListEntity)));
      verify(() => repository.getCars());
    });

    test('- Deve retornar um HttpError quando a requisição List<CarEntity> não for bem sucedida', () async {
      when(() => repository.getCars()).thenAnswer(
        (_) async => const Left(HttpError('404 Not Found')),
      );

      final result = await getCars();

      expect(result, const Left(HttpError('404 Not Found')));
      verify(() => repository.getCars());
    });
  });

  group('CarEntity', () {
    test('- Deve retornar um CarEntity', () async {
      // arrange
      when(() => repository.getCarById(any())).thenAnswer((_) async => Right(carEntity));

      //act
      final result = await getCar(1);

      //assert
      expect(result, equals(Right(carEntity)));
      verify(() => repository.getCarById(1)).called(1);
    });

    test('- Deve retornar um HttpError quando a requisição CarEntity não for bem sucedida', () async {
      when(() => repository.getCarById(any())).thenAnswer(
        (_) async => const Left(HttpError('404 Not Found')),
      );

      final result = await getCar(1);

      expect(result, const Left(HttpError('404 Not Found')));
      verify(() => repository.getCarById(1)).called(1);
    });
  });
}
