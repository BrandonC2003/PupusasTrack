abstract class AgregarProductoEvent {}

class SubmitProductoEvent extends AgregarProductoEvent {

  SubmitProductoEvent();
}

class ChangedNombreEvent extends AgregarProductoEvent {
  final String nombre;

  ChangedNombreEvent({required this.nombre});
}

class ChangedDescripcionEvent extends AgregarProductoEvent {
  final String descripcion;

  ChangedDescripcionEvent({required this.descripcion});
}

class ChangedPrecioEvent extends AgregarProductoEvent {
  final String precio;

  ChangedPrecioEvent({required this.precio});
}

class ChangedDisponibleEvent extends AgregarProductoEvent {
  final bool disponible;

  ChangedDisponibleEvent({required this.disponible});
}

class AddedDescuentoEvent extends AgregarProductoEvent {
  AddedDescuentoEvent();
}

class RemovedDescuentoEvent extends AgregarProductoEvent {
  final String descuentoId;

  RemovedDescuentoEvent({required this.descuentoId});
}

class ChangedDescuentoCantidadEvent extends AgregarProductoEvent {
  final String descuentoId;
  final String cantidad;

  ChangedDescuentoCantidadEvent({required this.descuentoId, required this.cantidad});
}

class ChangedDescuentoPrecioEvent extends AgregarProductoEvent {
  final String descuentoId;
  final String precio;

  ChangedDescuentoPrecioEvent({required this.descuentoId, required this.precio});
}

