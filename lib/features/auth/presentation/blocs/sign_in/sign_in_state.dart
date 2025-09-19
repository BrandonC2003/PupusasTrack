import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';

class SignInState {
  final String? email;
  final String? password;
  final bool obscurePassword;
  
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final FormStatus formStatus;

  const SignInState({
    this.email,
    this.password,
    this.obscurePassword = true,
    this.emailStatus = const UnknownEmailStatus(),
    this.passwordStatus = const UnknownPasswordStatus(),
    this.formStatus = const InitialFormStatus(),
  });

  SignInState copyWith({
    String? email,
    String? password,
    bool obscurePassword = true,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    FormStatus? formStatus,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}