import 'package:pupusas_track/features/auth/domain/entities/auth_user.dart';

abstract class AuthEvent {
  const AuthEvent();
}

/// Se dispara cuando cambia el usuario en Firebase (login / logout).
class AuthUserChanged extends AuthEvent {
  final AuthUser? user;

  const AuthUserChanged(this.user);
}

/// Se dispara cuando el usuario quiere cerrar sesión manualmente.
class AuthLogoutRequested extends AuthEvent {}
