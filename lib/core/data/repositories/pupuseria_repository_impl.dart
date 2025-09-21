import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pupusas_track/core/domain/repositories/pupuseria_repository.dart';

class PupuseriaRepositoryImpl extends PupuseriaRepository {
  final FirebaseFirestore firestore;
  static final String nombreColeccion = 'pupuserias';
  PupuseriaRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;
      
  @override
  Future<String> createPupuseria() async{
    DocumentReference docRef = await firestore
          .collection(nombreColeccion)
          .add({});
      
      return docRef.id;
  }

  @override
  Future<void> deletePupuseria(String id) async {
    await firestore.collection(nombreColeccion).doc(id).delete();
  }

  @override
  Future<bool> existsPupuseria(String id) async {
    DocumentSnapshot doc = await firestore
        .collection(nombreColeccion)
        .doc(id)
        .get();
    return doc.exists;
  }

}