import 'dart:convert';
import 'package:clean_teste/core/error/errors.dart';
import 'package:http/http.dart';
import 'package:clean_teste/data/models/car_model.dart';

abstract class CarRemoteDataSource {
  static const url = 'https://carros-springboot.herokuapp.com/api/v1/carros';

  Future<List<CarModel>> getCars();

  Future<CarModel> getCarById(int id);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final Client client;

  CarRemoteDataSourceImpl(this.client);

  @override
  Future<List<CarModel>> getCars() async {
    final response = await client.get(Uri.parse(CarRemoteDataSource.url));

    if (response.statusCode == 200) {
      final cars = json.decode(response.body);
      return List<CarModel>.from(cars.map((car) => CarModel.fromJson(car)));
    } else {
      throw const HttpError('Falha na requisição');
    }
  }

  @override
  Future<CarModel> getCarById(int id) async {
    final response = await client.get(Uri.parse(CarRemoteDataSource.url + '/$id'));

    if (response.statusCode == 200) {
      return CarModel.fromJson(json.decode(response.body));
    } else {
      throw const HttpError('Falha na requisição');
    }
  }
}
