import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';

class SignInState {
  final String? email;
  final String? password;
  final bool obscurePassword;
  final String? emailMessage;
  final String? passwordMessage;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final FormStatus formStatus;
  final String? formMessage;

  const SignInState({
    this.email,
    this.password,
    this.obscurePassword = true,
    this.emailMessage,
    this.passwordMessage,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.formStatus = FormStatus.initial,
    this.formMessage,
  });

  SignInState copyWith({
    String? email,
    String? password,
    bool obscurePassword = true,
    String? emailMessage,
    String? passwordMessage,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    FormStatus? formStatus,
    String? formMessage,
  }) {
    return SignInState(
      email: email ?? this.email,
      password: password ?? this.password,
      obscurePassword: obscurePassword,
      emailMessage: emailMessage ?? this.emailMessage,
      passwordMessage: passwordMessage ?? this.passwordMessage,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      formStatus: formStatus ?? this.formStatus,
      formMessage: formMessage ?? this.formMessage,
    );
  }
}