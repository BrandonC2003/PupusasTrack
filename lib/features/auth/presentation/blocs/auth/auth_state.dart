import 'package:pupusas_track/features/auth/domain/entities/auth_user.dart';

abstract class AuthState{
  const AuthState();
}

/// Estado inicial mientras se determina si hay usuario o no.
class AuthInitial extends AuthState {}

/// Usuario autenticado.
class Authenticated extends AuthState {
  final AuthUser user;

  const Authenticated(this.user);
}

/// Usuario no autenticado.
class Unauthenticated extends AuthState {}