import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';

class CatalogoProductoEntity {
  final String id;
  final String nombre;
  final TipoProducto tipoProducto;
  final String? descripcion;
  final double precio;
  final String? size;
  final List<DescuentoEntity>? descuentos;
  final bool disponible;

  CatalogoProductoEntity({
    required this.id,
    required this.nombre,
    required this.tipoProducto,
    this.descripcion,
    required this.precio,
    this.size,
    this.descuentos,
    required this.disponible
  });
}

class DescuentoEntity{
  final int cantidad;
  final double precio;

  DescuentoEntity({required this.cantidad, required this.precio});
}