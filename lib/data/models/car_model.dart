import 'package:clean_teste/domain/entities/entities.dart';

class CarModel extends CarEntity {
  const CarModel({
    required int id,
    String? name,
    String? type,
    String? description,
    String? photoUrl,
  }) : super(
          id: id,
          name: name,
          type: type,
          description: description,
          photoUrl: photoUrl,
        );

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      name: json['name'],
      type: json['tipo'],
      description: json['descricao'],
      photoUrl: json['urlFoto'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name ?? '',
      'tipo': type ?? '',
      'descricao': description ?? '',
      'urlFoto': photoUrl ?? '',
    };
  }
}
