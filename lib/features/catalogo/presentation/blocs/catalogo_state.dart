import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';

abstract class CatalogoState {}

class CatalogoInitial extends CatalogoState {}

class CatalogoLoading extends CatalogoState {}

class CatalogoLoaded extends CatalogoState {
  final List<CatalogoProductoEntity> pupusas;
  final List<CatalogoProductoEntity> bebidas;
  final List<MaterialEntity> materiales;

  CatalogoLoaded({
    required this.pupusas,
    required this.bebidas,
    required this.materiales,
  });
}

class CatalogoError extends CatalogoState {
  final String errorMessage;
  CatalogoError({required this.errorMessage});
}
