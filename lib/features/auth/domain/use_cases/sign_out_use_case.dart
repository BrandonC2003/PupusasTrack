import 'package:pupusas_track/core/domain/services/session_service.dart';

import '../repositories/auth_repository.dart';

class SignOutUseCase {
  final AuthRepository authRepository;
  final SessionService sessionService;

  SignOutUseCase({required this.authRepository, required this.sessionService});

  Future<void> call() async {
    try {
      await authRepository.signOut();
      await sessionService.cleaIdPupuseria();
    } catch (error) {
      throw Exception(error);
    }
  }
}