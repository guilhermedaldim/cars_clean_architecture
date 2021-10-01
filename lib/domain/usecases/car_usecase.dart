import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/domain/entities/entities.dart';
import 'package:clean_teste/domain/repositories/repositories.dart';
import 'package:dartz/dartz.dart';

class GetCars {
  final CarRepository repository;

  GetCars(this.repository);

  Future<Either<Failure, List<CarEntity>>> call() async => repository.getCars();
}

class GetCarById {
  final CarRepository repository;

  GetCarById(this.repository);

  Future<Either<Failure, CarEntity>> call(int id) async => repository.getCarById(id);
}
