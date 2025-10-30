import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';
import 'package:pupusas_track/core/utils/enum_utils.dart';

class CatalogoProductoModel {
  final String id;
  final String nombre;
  final TipoProducto tipoProducto;
  final String? descripcion;
  final double precio;
  final String? size;
  final List<DescuentoModel>? descuentos;
  final bool disponible;

  CatalogoProductoModel({
    required this.id,
    required this.nombre,
    required this.tipoProducto,
    this.descripcion,
    required this.precio,
    this.size,
    this.descuentos,
    required this.disponible,
  });

  factory CatalogoProductoModel.fromEntity(CatalogoProductoEntity entity) {
    return CatalogoProductoModel(
      id: entity.id,
      nombre: entity.nombre,
      descripcion: entity.descripcion,
      tipoProducto: entity.tipoProducto,
      precio: entity.precio,
      descuentos: entity.descuentos
          ?.map((descuento) => DescuentoModel.fromEntity(descuento))
          .toList() ?? [],
      disponible: entity.disponible,
    );
  }

  factory CatalogoProductoModel.fromFirestore(DocumentSnapshot doc) {
    final map = doc.data() as Map<String, dynamic>;
    // tipoProducto is stored as a String in Firestore; convert to enum
    final tipoStr = map['tipoProducto'] as String? ?? '';
    final tipoProducto = enumFromName<TipoProducto>(TipoProducto.values, tipoStr, TipoProducto.pupusa);

    return CatalogoProductoModel(
      id: doc.id,
      nombre: map['nombre'] ?? '',
      descripcion: map['descripcion'],
      tipoProducto: tipoProducto,
      precio: map['precio'] ?? '',
      size: map['size'],
      descuentos: (map['descuentos'] as List<dynamic>?)
          ?.map((item) => DescuentoModel.fromMap(item))
          .toList() ?? [],
      disponible: map['disponible'] ?? '',
    );
  }

  CatalogoProductoEntity toEntity(){
    return CatalogoProductoEntity(
      id: id, 
      nombre: nombre, 
      descripcion: descripcion,
      tipoProducto: tipoProducto, 
      precio: precio, 
      descuentos: descuentos?.map((descuento) => descuento.toEntity()).toList() ?? [],
      disponible: disponible);
  }

  Map<String, dynamic> toFirestore(){
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'tipoProducto': enumToName(tipoProducto),
      'precio': precio,
      'size': size,
      'descuentos': descuentos?.map((descuento) => descuento.toMap()),
      'disponible': disponible
    };
  }
}

class DescuentoModel {
  final int cantidad;
  final double precio;

  DescuentoModel({required this.cantidad, required this.precio});

  factory DescuentoModel.fromEntity(DescuentoEntity entity) =>
      DescuentoModel(cantidad: entity.cantidad, precio: entity.precio);

  factory DescuentoModel.fromMap(Map<String, dynamic> map) {
    return DescuentoModel(
      cantidad: map['cantidad'] ?? '',
      precio: map['precio'] ?? '',
    );
  }

  DescuentoEntity toEntity() =>
      DescuentoEntity(cantidad: cantidad, precio: precio);

  Map<String, dynamic> toMap() {
    return {'cantidad': cantidad, 'precio': precio};
  }
}
