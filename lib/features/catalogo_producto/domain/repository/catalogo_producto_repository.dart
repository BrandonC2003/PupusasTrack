import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';

abstract class CatalogoProductoRepository {
  
  Future<List<CatalogoProductoEntity>> obtenerProductos();

  Future<void> agregarProducto(CatalogoProductoEntity producto);

  Future<void> actualizarProducto(CatalogoProductoEntity producto);
}