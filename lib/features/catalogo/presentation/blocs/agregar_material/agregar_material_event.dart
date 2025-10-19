abstract class AgregarMaterialEvent {}

class NombreChanged extends AgregarMaterialEvent {
  final String name;

  NombreChanged(this.name);
}

class DescripcionChanged extends AgregarMaterialEvent {
  final String descripcion;

  DescripcionChanged(this.descripcion);
}

class AgregarMaterial extends AgregarMaterialEvent {}