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
    if (await network.isConnected) {
      try {
        final result = await remoteDataSource.getCars();
        localDataSource.setCars(result);
        return Right(result);
      } catch (e) {
        return const Left(ServerError('Falha na requisição'));
      }
    } else {
      try {
        final result = localDataSource.getCars();
        return Right(result);
      } catch (e) {
        return const Left(CacheError('Falha ao recuperar Cache'));
      }
    }
  }

  @override
  Future<Either<Failure, CarEntity>> getCarById(int id) async {
    if (await network.isConnected) {
      try {
        final result = await remoteDataSource.getCarById(id);
        return Right(result);
      } catch (e) {
        return const Left(ServerError('Falha na requisição'));
      }
    } else {
      try {
        final result = localDataSource.getCar(id);
        return Right(result!);
      } catch (e) {
        return const Left(CacheError('Falha ao recuperar Cache'));
      }
    }
  }
}
