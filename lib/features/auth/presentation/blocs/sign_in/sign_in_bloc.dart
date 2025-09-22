import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pupusas_track/core/utils/firebase_auth_error_handler.dart';
import '../../../domain/use_cases/sign_in_use_case.dart';
import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';
import 'sign_in_event.dart';
import 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final SignInUseCase _signInUseCase;
  SignInBloc({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase,
      super(SignInState()) {
    on<PasswordChanged>((event, emit) {
      if (event.password.isEmpty) {
        emit(
          state.copyWith(
            passwordStatus: InvalidPasswordStatus(message: "Ingrese la contraseña"),
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          password: event.password,
          passwordStatus: ValidPasswordStatus(),
        ),
      );
    });

    on<EmailChanged>((event, emit) {
      final emailRegExp = RegExp(
        r'^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$',
      );

      if (!emailRegExp.hasMatch(event.email)) {
        emit(
          state.copyWith(
            emailStatus: InvalidEmailStatus(message: "Dirección de correo inválida"),
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          email: event.email,
          emailStatus: ValidEmailStatus(),
        ),
      );
    });

    on<ToggleObscurePassword>((event, emit) {
      emit(state.copyWith(obscurePassword: !state.obscurePassword));
    });

    on<SignInSubmitted>((event, emit) async {
      if (state.emailStatus is! ValidEmailStatus ||
          state.passwordStatus is! ValidPasswordStatus) {
        emit(state.copyWith(formStatus: InvalidFormStatus(message: "Completa los campos correctamente")));
        emit(state.copyWith(formStatus: InitialFormStatus()));
        return;
      }

      emit(state.copyWith(formStatus: SubmissionInProgress()));
      try {
        await _signInUseCase(
          SignInParams(email: state.email!, password: state.password!),
        );
        emit(state.copyWith(formStatus: SubmissionSuccess(message: "Inicio de sesión exitoso")));
      }
      catch (err) {
        String friendlyMessage = FirebaseAuthErrorHandler.getGenericErrorMessage(err);
        emit(state.copyWith(formStatus: SubmissionFailure(message: friendlyMessage)));
      }
      emit(state.copyWith(formStatus: InitialFormStatus()));
    });
  }
}
