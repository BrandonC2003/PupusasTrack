import 'package:pupusas_track/features/catalogo/presentation/blocs/actualizar_producto/actualizar_producto_state.dart';

abstract class ActualizarProductoEvent {}

class SubmitProductoEvent extends ActualizarProductoEvent {

  SubmitProductoEvent();
}


class SetInitialValuesEvent extends ActualizarProductoEvent {
    final String id;
    final String nombre;
    final String descripcion;
    final double precio;
    final bool disponible;
    final List<Descuento> descuentos;

  SetInitialValuesEvent({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.disponible,
    required this.descuentos,
  });
}

class ChangedNombreEvent extends ActualizarProductoEvent {
  final String nombre;

  ChangedNombreEvent({required this.nombre});
}

class ChangedDescripcionEvent extends ActualizarProductoEvent {
  final String descripcion;

  ChangedDescripcionEvent({required this.descripcion});
}

class ChangedPrecioEvent extends ActualizarProductoEvent {
  final String precio;

  ChangedPrecioEvent({required this.precio});
}

class ChangedDisponibleEvent extends ActualizarProductoEvent {
  final bool disponible;

  ChangedDisponibleEvent({required this.disponible});
}

class AddedDescuentoEvent extends ActualizarProductoEvent {
  AddedDescuentoEvent();
}

class RemovedDescuentoEvent extends ActualizarProductoEvent {
  final String descuentoId;

  RemovedDescuentoEvent({required this.descuentoId});
}

class ChangedDescuentoCantidadEvent extends ActualizarProductoEvent {
  final String descuentoId;
  final String cantidad;

  ChangedDescuentoCantidadEvent({required this.descuentoId, required this.cantidad});
}

class ChangedDescuentoPrecioEvent extends ActualizarProductoEvent {
  final String descuentoId;
  final String precio;

  ChangedDescuentoPrecioEvent({required this.descuentoId, required this.precio});
}

