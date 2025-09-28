import 'package:pupusas_track/core/domain/repositories/user_repository.dart';
import 'package:pupusas_track/core/domain/services/session_service.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final SessionService sessionService;

  SignInUseCase(this.authRepository, this.userRepository, this.sessionService);

  Future<AuthUser> call(SignInParams params) async {
    try {
      var authUser = await authRepository.signIn(
        email: params.email,
        password: params.password,
      );

      //Recupero la informacion del usuario para saber a cual pupuseria pertenece
      //y guardo el id de pupuseria en sesion
      var userEnty = await userRepository.getUser(authUser.id);
      sessionService.setIdPupuseria(userEnty!.idPupuseria);

      return authUser;
    } on ArgumentError catch (error) {
      throw Exception(error);
    } catch (error) {
      throw Exception(error);
    }
  }
}

class SignInParams {
  final String email;
  final String password;

  SignInParams({
    required this.email,
    required this.password,
  });
}