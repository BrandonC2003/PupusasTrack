import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/repository/material_repository.dart';

class ActualizarMaterialUseCase {
  final MaterialRepository materialRepository;

  ActualizarMaterialUseCase({required this.materialRepository});

  Future<void> call(MaterialEntity material) async {
    await materialRepository.actualizarMaterial(material);
  }

}