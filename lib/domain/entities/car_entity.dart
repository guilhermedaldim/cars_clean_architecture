import 'package:equatable/equatable.dart';

class CarEntity extends Equatable {
  final int id;
  final String? name;
  final String? type;
  final String? description;
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
