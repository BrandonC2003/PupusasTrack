abstract class SignInEvent {}

class PasswordChanged extends SignInEvent {
  String password;
  PasswordChanged(this.password);
}

class EmailChanged extends SignInEvent {
  String email;
  EmailChanged(this.email);
}
class ToggleObscurePassword extends SignInEvent {}
class SignInSubmitted extends SignInEvent {}