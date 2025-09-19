import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';

class SignUpState {
  //Datos del formulario
  final String? email;
  final String? password;

  //Estados
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final FormStatus formStatus;

  const SignUpState({
    this.email,
    this.password,
    this.emailStatus = const UnknownEmailStatus(),
    this.passwordStatus = const UnknownPasswordStatus(),
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? email,
    String? emailMessage,
    String? password,
    String? passwordMessage,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    FormStatus? formStatus,
    String? formMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}