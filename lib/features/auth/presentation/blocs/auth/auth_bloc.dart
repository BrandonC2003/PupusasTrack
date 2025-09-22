import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/features/auth/domain/entities/auth_user.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:pupusas_track/features/auth/domain/use_cases/stream_auth_user_use_case.dart';
import 'auth_event.dart';
import 'auth_state.dart';


class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final StreamAuthUserUseCase streamAuthUserUseCase;
  final SignOutUseCase signOutUseCase;
  late final StreamSubscription<AuthUser?> _userSubscription;

  AuthBloc({required this.signOutUseCase, required this.streamAuthUserUseCase}):super(AuthInitial()) {
    // Manejo de cambios de usuario
    on<AuthUserChanged>((event, emit) {
      if (event.user?.isEmpty == false) {
        emit(Authenticated(event.user!));
      } else {
        emit(Unauthenticated());
      }
    });

    // Suscripción al stream del usecase
    _userSubscription = streamAuthUserUseCase().listen((user) {
      add(AuthUserChanged(user));
    });

    on<AuthLogoutRequested>((event, emit) async {
      await signOutUseCase();
      emit(Unauthenticated());
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
