import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/repository/catalogo_producto_repository.dart';

class AgregarProductoUseCase {
  final CatalogoProductoRepository catalogoProductoRepository;

  AgregarProductoUseCase(this.catalogoProductoRepository);

  Future<void> call(CatalogoProductoEntity producto) async {
    await catalogoProductoRepository.agregarProducto(producto);
  }
}