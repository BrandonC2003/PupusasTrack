import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/repository/material_repository.dart';

class CrearMaterialInicialUseCase {
  final MaterialRepository materialRepository;

  CrearMaterialInicialUseCase({required this.materialRepository});

  Future<void> call() async{
    var arroz = MaterialEntity(nombre: 'Arroz', descripcion: '');
    var maiz = MaterialEntity(nombre: 'Maíz', descripcion: '');

    await materialRepository.crearMaterial(arroz);
    await materialRepository.crearMaterial(maiz);
  }

}