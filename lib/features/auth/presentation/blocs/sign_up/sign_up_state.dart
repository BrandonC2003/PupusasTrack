import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';

class SignUpState {
  final String? email;
  final String? emailMessage;
  final String? password;
  final String? passwordMessage;
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final FormStatus formStatus;
  final String? formMessage;

  const SignUpState({
    this.email,
    this.emailMessage,
    this.password,
    this.passwordMessage,
    this.emailStatus = EmailStatus.unknown,
    this.passwordStatus = PasswordStatus.unknown,
    this.formStatus = FormStatus.initial,
    this.formMessage,
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
      emailMessage: emailMessage ?? this.emailMessage,
      password: password ?? this.password,
      passwordMessage: passwordMessage ?? this.passwordMessage,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      formStatus: formStatus ?? this.formStatus,
      formMessage: formMessage ?? this.formMessage,
    );
  }
}