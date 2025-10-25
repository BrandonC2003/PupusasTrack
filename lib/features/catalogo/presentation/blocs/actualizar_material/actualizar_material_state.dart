import 'package:equatable/equatable.dart';

class ActualizarMaterialState extends Equatable {

  final String? idMaterial;
  final String nombre;
  final NombreStatus nombreStatus;
  final String nombreMessage;
  final String descripcion;
  final ActualizarMaterialStatus actualizarMaterialStatus;
  final String errorMessage;

  const ActualizarMaterialState({
    this.idMaterial,
    this.nombre = '',
    this.nombreStatus = NombreStatus.initial,
    this.nombreMessage = '',
    this.descripcion = '',
    this.actualizarMaterialStatus = ActualizarMaterialStatus.initial,
    this.errorMessage = '',
  });

  ActualizarMaterialState copyWith({
    String? idMaterial,
    String? nombre,
    NombreStatus? nombreStatus,
    String? nombreMessage,
    String? descripcion,
    ActualizarMaterialStatus? actualizarMaterialStatus,
    String? errorMessage,
  }) {
    return ActualizarMaterialState(
      idMaterial: idMaterial ?? this.idMaterial,
      nombre: nombre ?? this.nombre,
      nombreStatus: nombreStatus ?? this.nombreStatus,
      nombreMessage: nombreMessage ?? this.nombreMessage,
      descripcion: descripcion ?? this.descripcion,
      actualizarMaterialStatus: actualizarMaterialStatus ?? this.actualizarMaterialStatus,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [
    idMaterial,
    nombre,
    nombreStatus,
    descripcion,
    actualizarMaterialStatus
  ];
}

enum ActualizarMaterialStatus { initial, loading, success, failure }
enum NombreStatus { initial, valid, invalid }