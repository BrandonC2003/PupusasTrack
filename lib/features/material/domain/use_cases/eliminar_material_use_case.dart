import 'package:pupusas_track/features/material/domain/repository/material_repository.dart';

class EliminarMaterialUseCase{
  final MaterialRepository materialRepository;

  EliminarMaterialUseCase({required this.materialRepository});

  Future<void> call(String id) async{
    await materialRepository.eliminarMaterial(id);
  }
}