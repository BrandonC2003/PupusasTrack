import '../../domain/entities/user_entity.dart';

class UserModel  {
  final String nombre;
  final String idPupuseria;
  UserModel({
    required this.nombre,
    required this.idPupuseria,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      nombre: map['Nombre'] ?? '',
      idPupuseria: map['idPupuseria'] ?? '',
    );
  }

  factory UserModel.fromEntity(UserEntity entity){
    return UserModel(nombre: entity.nombre, idPupuseria: entity.idPupuseria);
  }

  Map<String, dynamic> toMap() {
    return {
      'Nombre': nombre,
      'idPupuseria': idPupuseria,
    };
  }

  UserEntity toEntity(){
    return UserEntity(nombre: nombre, idPupuseria: idPupuseria);
  }

}
