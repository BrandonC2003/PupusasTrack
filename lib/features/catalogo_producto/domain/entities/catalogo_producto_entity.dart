class CatalogoProductoEntity {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precio;
  final String? size;
  final List<Descuento>? descuentos;
  final bool disponible;

  CatalogoProductoEntity({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precio,
    this.size,
    this.descuentos,
    required this.disponible
  });
}

class Descuento{
  final int cantidad;
  final double precio;

  Descuento({required this.cantidad, required this.precio});
}