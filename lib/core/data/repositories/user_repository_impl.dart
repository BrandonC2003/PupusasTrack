import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../models/user_model.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final FirebaseFirestore _firestore;
  static final _nombrecoleccion = 'usuarios';

  UserRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createUser(UserEntity user) async {
    final userModel = user as UserModel;
    await _firestore.collection(_nombrecoleccion).add(userModel.toMap());
  }

  @override
  Future<UserEntity?> getUser(String id) async {
    final doc = await _firestore.collection(_nombrecoleccion).doc(id).get();
    if (doc.exists && doc.data() != null) {
  return UserModel.fromMap(doc.data()!) as UserEntity;
    }
    return null;
  }

  @override
  Future<void> updateUser(String id, UserEntity user) async {
    final userModel = user as UserModel;
    await _firestore.collection(_nombrecoleccion).doc(id).update(userModel.toMap());
  }

  @override
  Future<void> deleteUser(String id) async {
    await _firestore.collection(_nombrecoleccion).doc(id).delete();
  }
}
