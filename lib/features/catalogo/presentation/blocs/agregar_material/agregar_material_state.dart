abstract class AgregarMaterialState {}

class AgregarMaterialInitial extends AgregarMaterialState {}
class AgregarMaterialProcesando extends AgregarMaterialState {}
class AgregarMaterialExito extends AgregarMaterialState {}
class AgregarMaterialError extends AgregarMaterialState {
  final String mensaje;
  AgregarMaterialError(this.mensaje);
}

