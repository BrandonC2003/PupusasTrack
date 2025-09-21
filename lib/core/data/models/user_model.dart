import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.nombre,
    required super.idPupuseria,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nombre: map['Nombre'] ?? '',
      idPupuseria: map['idPupuseria'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'Nombre': nombre,
      'idPupuseria': idPupuseria,
    };
  }
}
