import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/enumerables/tipo_producto.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/repository/catalogo_producto_repository.dart';

class AgregarProductosInicialesUseCase {
  final CatalogoProductoRepository catalogoProductoRepository;

  AgregarProductosInicialesUseCase(this.catalogoProductoRepository);

  Future<void> call() async {
    var productos = [
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.pupusa,
        nombre: 'Pupusa de frijol con queso',
        descripcion: 'Deliciosa pupusa rellena de frijol y queso derretido.',
        precio: 0.35,
        disponible: true,
        descuentos: [DescuentoEntity(cantidad: 3, precio: 1.0)],
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.pupusa,
        nombre: 'Pupusa revuelta',
        descripcion: 'pupusa rellena de frijol, queso y chicharron.',
        precio: 0.35,
        disponible: true,
        descuentos: [DescuentoEntity(cantidad: 3, precio: 1.0)],
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.pupusa,
        nombre: 'Pupusa de queso',
        descripcion: 'Deliciosa pupusa de queso derretido',
        precio: 0.50,
        disponible: true
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.pupusa,
        nombre: 'Pupusa de ayote',
        descripcion: 'Pupusa queso con ayote',
        precio: 0.50,
        disponible: true
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.bebida,
        nombre: 'Coca Cola lata',
        descripcion: 'Refresco de cola bien frio',
        size: '355 ml',
        precio: 1.00,
        disponible: true
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.bebida,
        nombre: 'Fanta lata',
        descripcion: 'Refresco de naranja',
        size: '355 ml',
        precio: 1.00,
        disponible: true
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.bebida,
        nombre: 'Agua embotellada',
        descripcion: 'Agua pura bien fria',
        size: '500 ml',
        precio: 0.75,
        disponible: true
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.bebida,
        nombre: 'Fresco de orchata',
        descripcion: 'Fresco de orchata artesanal',
        size: 'vaso',
        precio: 0.25,
        disponible: true
      ),
      CatalogoProductoEntity(
        id: '',
        tipoProducto: TipoProducto.bebida,
        nombre: 'Fresco de jamaica',
        descripcion: 'Fresco de jamaica natural',
        size: 'vaso',
        precio: 0.25,
        disponible: false
      ),
    ];

    for (var producto in productos) {
      await catalogoProductoRepository.agregarProducto(producto);
    }
  }
}
