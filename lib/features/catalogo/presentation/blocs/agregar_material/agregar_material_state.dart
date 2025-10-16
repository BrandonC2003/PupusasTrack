import 'package:equatable/equatable.dart';

class AgregarMaterialState extends Equatable {

  final int? idMaterial;
  final String nombre;
  final NombreStatus nombreStatus;
  final String nombreMessage;
  final String descripcion;
  final AgregarMaterialStatus status;
  final String errorMessage;

  const AgregarMaterialState({
    this.idMaterial,
    this.nombre = '',
    this.nombreStatus = NombreStatus.initial,
    this.nombreMessage = '',
    this.descripcion = '',
    this.status = AgregarMaterialStatus.initial,
    this.errorMessage = '',
  });

  AgregarMaterialState copyWith({
    int? idMaterial,
    String? nombre,
    NombreStatus? nombreStatus,
    String? nombreMessage,
    String? descripcion,
    AgregarMaterialStatus? status,
    String? errorMessage,
  }) {
    return AgregarMaterialState(
      idMaterial: idMaterial ?? this.idMaterial,
      nombre: nombre ?? this.nombre,
      nombreStatus: nombreStatus ?? this.nombreStatus,
      nombreMessage: nombreMessage ?? this.nombreMessage,
      descripcion: descripcion ?? this.descripcion,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
  
  @override
  List<Object?> get props => [
    idMaterial,
    nombre,
    nombreStatus,
    descripcion,
    status
  ];
}

enum AgregarMaterialStatus { initial, loading, success, failure }
enum NombreStatus { initial, valid, invalid }