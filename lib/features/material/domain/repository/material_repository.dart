import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';

abstract class MaterialRepository {
  Future<void> crearMaterial(MaterialEntity material);
  Future<List<MaterialEntity>> obtenerMateriales();
  Future<void> actualizarMaterial(MaterialEntity material);
  Future<void> eliminarMaterial(String id);
}