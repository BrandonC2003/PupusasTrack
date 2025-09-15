import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';
import '../value_objects/email.dart';
import '../value_objects/password.dart';

class SignInUseCase {
  final AuthRepository authRepository;

  SignInUseCase({required this.authRepository});

  Future<AuthUser> call(SignInParams params) async {
    try {
      return await authRepository.signIn(
        email: params.email.value,
        password: params.password.value,
      );
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class SignInParams {
  final Email email;
  final Password password;

  SignInParams({
    required this.email,
    required this.password,
  });
}