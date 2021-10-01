import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/domain/helpers/loading_status.dart';
import 'package:clean_teste/domain/usecases/car_usecase.dart';
import 'package:clean_teste/presentation/controllers/detail_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_entity_mock.dart';

class GetCarByIdMock extends Mock implements GetCarById {}

main() {
  late DetailController controller;
  late GetCarById getCarByIdMock;

  setUp(() {
    controller = DetailController();
    getCarByIdMock = GetCarByIdMock();
    Get.put<GetCarById>(getCarByIdMock);
  });

  tearDown(() => Get.reset());

  test('Deve retorna um CarEntity do caso de uso', () async {
    when(() => getCarByIdMock(any())).thenAnswer((_) async => Right(carEntity));

    await controller.getCarById(1, showError: false);

    expect(controller.car, carEntity);
    expect(controller.loadingStatus, LoadingStatus.completed);
  });

  test('Deve retornar um LoadingStatus.error quando o caso de uso obtiver um erro', () async {
    when(() => getCarByIdMock(any())).thenAnswer((_) async => const Left(ServerError('Falha na requisição')));

    await controller.getCarById(1, showError: false);

    expect(controller.loadingStatus, LoadingStatus.error);
  });
}
