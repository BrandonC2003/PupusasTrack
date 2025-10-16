abstract class AgregarMaterialEvent {}

class NombreChanged extends AgregarMaterialEvent {
  final String name;

  NombreChanged(this.name);
}

class GuardarMaterial extends AgregarMaterialEvent {
  final String nombre;
  final String descripcion;

  GuardarMaterial({
    required this.nombre,
    required this.descripcion,
  });
}