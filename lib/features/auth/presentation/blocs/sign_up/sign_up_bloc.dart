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
            passwordStatus: InvalidPasswordStatus(message: "Ingrese la contraseña")
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

    on<SignUpSubmitted>((event, emit) async {
      if (state.emailStatus is! ValidEmailStatus ||
          state.passwordStatus is! ValidPasswordStatus) {
        emit(state.copyWith(formStatus: InvalidFormStatus(message: "Completa los campos correctamente")));
        emit(state.copyWith(formStatus: InitialFormStatus()));
        return;
      }

      emit(state.copyWith(formStatus: SubmissionInProgress()));
      try {
        await _signUpUseCase(
          SignUpParams(email: state.email!, password: state.password!),
        );
        emit(state.copyWith(formStatus: SubmissionSuccess(message: "Usuario registrado exitosamente")));
      } catch (err) {
        emit(state.copyWith(formStatus: SubmissionFailure(message: err.toString())));
      }
    });
  }
}
