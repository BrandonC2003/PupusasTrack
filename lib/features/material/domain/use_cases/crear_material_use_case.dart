import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/repository/material_repository.dart';

class CrearMaterialUseCase {
  final MaterialRepository materialRepository;

  CrearMaterialUseCase({required this.materialRepository});

  Future<void> call(MaterialEntity material) async{
    await materialRepository.crearMaterial(material);
  }
}