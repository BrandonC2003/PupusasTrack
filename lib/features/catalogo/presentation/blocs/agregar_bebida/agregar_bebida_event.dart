abstract class AgregarBebidaEvent {}

class SubmitBebidaEvent extends AgregarBebidaEvent {

  SubmitBebidaEvent();
}

class ChangedNombreEvent extends AgregarBebidaEvent {
  final String nombre;

  ChangedNombreEvent({required this.nombre});
}

class ChangedDescripcionEvent extends AgregarBebidaEvent {
  final String descripcion;

  ChangedDescripcionEvent({required this.descripcion});
}

class ChangedPrecioEvent extends AgregarBebidaEvent {
  final String precio;

  ChangedPrecioEvent({required this.precio});
}

class ChangedDisponibleEvent extends AgregarBebidaEvent {
  final bool disponible;

  ChangedDisponibleEvent({required this.disponible});
}

class ChangedSizeEvent extends AgregarBebidaEvent {
  final String size;

  ChangedSizeEvent({required this.size});
}
