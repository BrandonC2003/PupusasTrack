import 'package:pupusas_track/core/domain/entities/user_entity.dart';
import 'package:pupusas_track/core/domain/repositories/user_repository.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;
  final UserRepository userRepository;

  SignUpUseCase({
    required this.authRepository,
    required this.userRepository
  });

  Future<AuthUser> call(SignUpParams params) async {

    var authUser = await authRepository.signUp(
      email: params.email,
      password: params.password,
    );

    var userEntity = UserEntity(
      nombre: params.nombre,
      idPupuseria: params.idPupuseria,
    );

    await userRepository.createUser(userEntity);

    authUser = authUser.copyWith(idPupuseria: userEntity.idPupuseria);

    return authUser;
  }
}

class SignUpParams {
  final String email;
  final String password;
  final String nombre;
  String idPupuseria;

  SignUpParams({
    required this.email,
    required this.password,
    required this.nombre,
    this.idPupuseria = '',
  });
}
