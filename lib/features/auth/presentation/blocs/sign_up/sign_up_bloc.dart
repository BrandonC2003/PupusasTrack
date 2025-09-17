import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/sign_up_use_case.dart';
import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';
import 'sign_up_event.dart';
import 'sign_up_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final SignUpUseCase _signUpUseCase;
  SignUpBloc({required SignUpUseCase signUpUseCase})
    : _signUpUseCase = signUpUseCase,
      super(SignUpState()) {

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

    on<SignUpSubmitted>((event, emit) async {
      if (!(state.emailStatus == EmailStatus.valid) ||
          !(state.passwordStatus == PasswordStatus.valid)) {
        emit(state.copyWith(formStatus: FormStatus.invalid));
        emit(state.copyWith(formStatus: FormStatus.initial));
        return;
      }

      emit(state.copyWith(formStatus: FormStatus.submissionInProgress));
      try {
        await _signUpUseCase(
          SignUpParams(email: state.email!, password: state.password!),
        );
        emit(state.copyWith(formStatus: FormStatus.submissionSuccess));
      } catch (err) {
        emit(state.copyWith(formStatus: FormStatus.submissionFailure));
      }
    });
  }
}
