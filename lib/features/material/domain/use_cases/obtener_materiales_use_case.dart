import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/repository/material_repository.dart';

class ObtenerMaterialesUseCase {
  final MaterialRepository materialRepository;
  ObtenerMaterialesUseCase({required this.materialRepository});

  Future<List<MaterialEntity>> call() async {
    return await materialRepository.obtenerMateriales();
  }
}