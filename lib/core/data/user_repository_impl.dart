import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../domain/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore;
  UserRepositoryImpl({FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(UserModel user) async {
    await firestore.collection('usuarios').add(user.toMap());
  }

  @override
  Future<UserModel?> getUser(String id) async {
    final doc = await firestore.collection('usuarios').doc(id).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return null;
  }

  @override
  Future<void> updateUser(String id, UserModel user) async {
    await firestore.collection('usuarios').doc(id).update(user.toMap());
  }

  @override
  Future<void> deleteUser(String id) async {
    await firestore.collection('usuarios').doc(id).delete();
  }
}
