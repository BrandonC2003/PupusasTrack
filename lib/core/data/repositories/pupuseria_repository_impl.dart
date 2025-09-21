import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupusas_track/core/domain/repositories/pupuseria_repository.dart';

class PupuseriaRepositoryImpl extends PupuseriaRepository {
  final FirebaseFirestore _firestore;
  static final String _nombreColeccion = 'pupuserias';
  PupuseriaRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;
      
  @override
  Future<String> createPupuseria() async{
    DocumentReference docRef = await _firestore
          .collection(_nombreColeccion)
          .add({});
      
      return docRef.id;
  }

  @override
  Future<void> deletePupuseria(String id) async {
    await _firestore.collection(_nombreColeccion).doc(id).delete();
  }

  @override
  Future<bool> existsPupuseria(String id) async {
    DocumentSnapshot doc = await _firestore
        .collection(_nombreColeccion)
        .doc(id)
        .get();
    return doc.exists;
  }

}