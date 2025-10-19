import '../entities/user_entity.dart';

abstract class UserRepository {
  Future<void> createUser(String id, UserEntity user);
  Future<UserEntity?> getUser(String id);
  Future<void> updateUser(String id, UserEntity user);
  Future<void> deleteUser(String id);
}
