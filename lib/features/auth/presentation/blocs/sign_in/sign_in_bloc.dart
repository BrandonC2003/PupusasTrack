import 'package:flutter_bloc/flutter_bloc.dart';
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
            passwordStatus: PasswordStatus.invalid,
            passwordMessage: "Ingrese la contraseña",
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          password: event.password,
          passwordStatus: PasswordStatus.valid,
          passwordMessage: null,
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
            emailStatus: EmailStatus.invalid,
            emailMessage: "Dirección de correo inválida",
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          email: event.email,
          emailStatus: EmailStatus.valid,
          emailMessage: null,
        ),
      );
    });

    on<SignInSubmitted>((event, emit) async {
      if (!(state.emailStatus == EmailStatus.valid) ||
          !(state.passwordStatus == PasswordStatus.valid)) {
        emit(state.copyWith(formStatus: FormStatus.invalid));
        emit(state.copyWith(formStatus: FormStatus.initial));
        return;
      }

      emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
      try {
        await _signInUseCase(
          SignInParams(email: state.email!, password: state.password!),
        );
        emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
      } catch (err) {
        emit(state.copyWith(formStatus: FormStatus.submissionFailure));
      }
    });
  }
}
