import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/domain/helpers/loading_status.dart';
import 'package:clean_teste/domain/usecases/car_usecase.dart';
import 'package:clean_teste/presentation/controllers/home_controller.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/car_entity_mock.dart';

class GetCarsMock extends Mock implements GetCars {}

main() {
  late HomeController controller;
  late GetCars getCarsMock;

  setUp(() {
    controller = HomeController();
    getCarsMock = GetCarsMock();
    Get.put<GetCars>(getCarsMock);
  });

  tearDown(() => Get.reset());

  test('Deve retornar uma List<CarEntity> do caso de uso', () async {
    when(() => getCarsMock()).thenAnswer((_) async => Right(carListEntity));

    await controller.getCars(showError: false);

    expect(controller.cars, carListEntity);
    expect(controller.loadingStatus, LoadingStatus.completed);
  });

  test('Deve retornar um LoadingStatus.error quando o caso de uso obtiver um erro', () async {
    when(() => getCarsMock()).thenAnswer((_) async => const Left(ServerError('Falha na requisição')));

    await controller.getCars(showError: false);

    expect(controller.loadingStatus, LoadingStatus.error);
  });
}
