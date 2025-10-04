import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';

class MaterialModel {
  final String? id;
  final String nombre;
  final String descripcion;

  MaterialModel({this.id, required this.nombre, required this.descripcion});

  factory MaterialModel.fromEntity(MaterialEntity entity) {
    return MaterialModel(
      id: entity.id,
      nombre: entity.nombre,
      descripcion: entity.descripcion,
    );
  }

  factory MaterialModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    return MaterialModel(
      id: doc.id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'] ?? '',
    );
  }

  MaterialEntity toEntity() {
    return MaterialEntity(id: id, nombre: nombre, descripcion: descripcion);
  }

  Map<String, dynamic> toFirestore(){
    return {
      'nombre': nombre,
      'descripcion': descripcion
    };
  }
}
