abstract class ActualizarMaterialEvent {}

class SetIdMaterial extends ActualizarMaterialEvent {
  final String idMaterial;

  SetIdMaterial(this.idMaterial);
}

class NombreChanged extends ActualizarMaterialEvent {
  final String name;

  NombreChanged(this.name);
}

class DescripcionChanged extends ActualizarMaterialEvent {
  final String descripcion;

  DescripcionChanged(this.descripcion);
}

class SubmitActualizarMaterial extends ActualizarMaterialEvent {}