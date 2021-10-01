import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/domain/entities/entities.dart';
import 'package:dartz/dartz.dart';

abstract class CarRepository {
  Future<Either<Failure, List<CarEntity>>> getCars();

  Future<Either<Failure, CarEntity>> getCarById(int id);
}
