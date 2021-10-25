import 'package:clean_teste/core/network/network.dart';
import 'package:clean_teste/data/datasources/car_local_datasource.dart';
import 'package:clean_teste/data/datasources/car_remote_datasource.dart';
import 'package:clean_teste/domain/entities/car_entity.dart';
import 'package:clean_teste/core/error/errors.dart';
import 'package:clean_teste/domain/repositories/car_repository.dart';
import 'package:dartz/dartz.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;
  final CarLocalDataSource localDataSource;
  final Network network;

  CarRepositoryImpl(this.remoteDataSource, this.localDataSource, this.network);

  @override
  Future<Either<Failure, List<CarEntity>>> getCars() async {
    network.isConnected.then((connected) {
      if (connected) {
        remoteDataSource.getCars().then((cars) {
          localDataSource.setCars(cars);
        });
      }
    });

    try {
      final result = localDataSource.getCars();
      return Right(result);
    } catch (e) {
      return const Left(CacheError('Falha ao recuperar Cache'));
    }
  }

  @override
  Future<Either<Failure, CarEntity>> getCarById(int id) async {
    network.isConnected.then((connected) {
      if (connected) {
        remoteDataSource.getCarById(id);
      }
    });

    try {
      final result = localDataSource.getCarById(id);
      return Right(result);
    } catch (e) {
      return const Left(CacheError('Falha ao recuperar Cache'));
    }
  }
}
