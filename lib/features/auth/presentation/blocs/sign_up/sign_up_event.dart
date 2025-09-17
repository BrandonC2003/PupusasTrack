abstract class SignUpEvent {}

class PasswordChanged extends SignUpEvent {
  String password;
  PasswordChanged(this.password);
}

class EmailChanged extends SignUpEvent {
  String email;
  EmailChanged(this.email);
}
class SignUpSubmitted extends SignUpEvent {}