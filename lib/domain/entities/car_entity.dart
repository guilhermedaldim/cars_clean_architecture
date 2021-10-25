import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

class CarEntity extends Equatable {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? type;
  @HiveField(3)
  final String? description;
  @HiveField(4)
  final String? photoUrl;

  const CarEntity({
    required this.id,
    this.name,
    this.type,
    this.description,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, name, type, description, photoUrl];
}
