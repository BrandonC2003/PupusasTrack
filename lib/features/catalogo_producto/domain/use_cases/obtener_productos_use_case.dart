import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/repository/catalogo_producto_repository.dart';

class ObtenerProductosUseCase {
  final CatalogoProductoRepository catalogoProductoRepository;

  ObtenerProductosUseCase(this.catalogoProductoRepository);

  Future<List<CatalogoProductoEntity>> call() async {
    return await  catalogoProductoRepository.obtenerProductos();
  }
}