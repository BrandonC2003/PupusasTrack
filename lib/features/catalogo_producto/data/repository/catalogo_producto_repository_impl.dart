import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupusas_track/core/domain/services/session_service.dart';
import 'package:pupusas_track/features/catalogo_producto/data/model/catalogo_producto_model.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/entities/catalogo_producto_entity.dart';
import 'package:pupusas_track/features/catalogo_producto/domain/repository/catalogo_producto_repository.dart';

class CatalogoProductoRepositoryImpl implements CatalogoProductoRepository{
  final FirebaseFirestore firestore;
  final SessionService sessionService;

  static const _pupuseriaCollectionKey = 'pupuserias';
  static const _catalogoProductosCollectionKey = 'catalogo-productos';

  CatalogoProductoRepositoryImpl({required this.firestore, required this.sessionService});

  @override
  Future<void> actualizarProducto(CatalogoProductoEntity producto) async {
    final idPupuseria = await sessionService.getIdPupuseria();
    await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_catalogoProductosCollectionKey)
                      .doc(producto.id)
                      .update(CatalogoProductoModel.fromEntity(producto).toFirestore());
  }

  @override
  Future<void> agregarProducto(CatalogoProductoEntity producto) async {
    final idPupuseria = await sessionService.getIdPupuseria();
    await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_catalogoProductosCollectionKey)
                      .add(CatalogoProductoModel.fromEntity(producto).toFirestore());
  }

  @override
  Future<List<CatalogoProductoEntity>> obtenerProductos() async {
    final idPupuseria = await sessionService.getIdPupuseria();
    final snapshot = await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_catalogoProductosCollectionKey)
                      .get();
    return snapshot.docs.map((map) => CatalogoProductoModel.fromFirestore(map).toEntity()).toList();
  }

}