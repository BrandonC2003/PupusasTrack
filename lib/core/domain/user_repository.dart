import '../models/user_model.dart';

abstract class UserRepository {
  Future<void> createUser(UserModel user);
  Future<UserModel?> getUser(String id);
  Future<void> updateUser(String id, UserModel user);
  Future<void> deleteUser(String id);
}
