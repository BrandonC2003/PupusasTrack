import 'package:pupusas_track/core/domain/entities/user_entity.dart';
import 'package:pupusas_track/core/domain/repositories/pupuseria_repository.dart';
import 'package:pupusas_track/core/domain/repositories/user_repository.dart';
import 'package:pupusas_track/core/errors/validation_error.dart';

import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository authRepository;
  final UserRepository userRepository;
  final PupuseriaRepository pupuseriaRepository;

  SignUpUseCase({
    required this.authRepository,
    required this.userRepository,
    required this.pupuseriaRepository,
  });

  Future<AuthUser> call(SignUpParams params) async {
    if (params.idPupuseria != '') {
      var existsPupuseria = await pupuseriaRepository.existsPupuseria(
        params.idPupuseria,
      );
      if (!existsPupuseria) {
        throw ValidationError('El id de pupuseria ingresado no ha sido encontrado');
      }
    }

    var authUser = await authRepository.signUp(
      email: params.email,
      password: params.password,
    );

    //Si no ingreso un id de pupuseria se creara uno nuevo para asignarlo
    if (params.idPupuseria == '') {
      params.idPupuseria = await pupuseriaRepository.createPupuseria();
    }

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
