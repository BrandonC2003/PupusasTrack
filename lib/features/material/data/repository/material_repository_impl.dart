import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupusas_track/core/domain/services/session_service.dart';
import 'package:pupusas_track/features/material/data/model/material_model.dart';
import 'package:pupusas_track/features/material/domain/entities/material_entity.dart';
import 'package:pupusas_track/features/material/domain/repository/material_repository.dart';

class MaterialRepositoryImpl implements MaterialRepository{
  final FirebaseFirestore firestore;
  final SessionService sessionService;
  static const _pupuseriaCollectionKey = 'pupuserias';
  static const _materialCollectionKey = 'materiales';

  MaterialRepositoryImpl({required this.firestore, required this.sessionService});

  @override
  Future<void> actualizarMaterial(MaterialEntity material) async{
    final idPupuseria = await sessionService.getIdPupuseria();
    await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_materialCollectionKey)
                      .doc(material.id)
                      .update(MaterialModel.fromEntity(material).toFirestore());
  }

  @override
  Future<void> crearMaterial(MaterialEntity material) async {
    final idPupuseria = await sessionService.getIdPupuseria();
    await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_materialCollectionKey)
                      .add(MaterialModel.fromEntity(material).toFirestore());
  }

  @override
  Future<void> eliminarMaterial(String id) async {
    final idPupuseria = await sessionService.getIdPupuseria();
    await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_materialCollectionKey)
                      .doc(id)
                      .delete();
  }

  @override
  Future<List<MaterialEntity>> obtenerMateriales() async {
    final idPupuseria = await sessionService.getIdPupuseria();
    final snapshot = await firestore.collection(_pupuseriaCollectionKey)
                      .doc(idPupuseria)
                      .collection(_materialCollectionKey)
                      .get();

    return snapshot.docs.map((map) => MaterialModel.fromFirestore(map).toEntity()).toList();
  }
}