import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore firestore;
  static final _nombrecoleccion = 'usuarios';

  UserRepositoryImpl({required this.firestore});

  @override
  Future<void> createUser(String id, UserEntity user) async {
    await firestore
        .collection(_nombrecoleccion)
        .doc(id)
        .set(UserModel.fromEntity(user).toMap());
  }

  @override
  Future<UserEntity?> getUser(String id) async {
    final doc = await firestore.collection(_nombrecoleccion).doc(id).get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!).toEntity();
    }
    return null;
  }

  @override
  Future<void> updateUser(String id, UserEntity user) async {
    await firestore
        .collection(_nombrecoleccion)
        .doc(id)
        .update(UserModel.fromEntity(user).toMap());
  }

  @override
  Future<void> deleteUser(String id) async {
    await firestore.collection(_nombrecoleccion).doc(id).delete();
  }
}
