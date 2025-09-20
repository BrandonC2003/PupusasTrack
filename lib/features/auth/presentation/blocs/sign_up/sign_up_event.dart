abstract class SignUpEvent {}

class PasswordChanged extends SignUpEvent {
  String password;
  PasswordChanged(this.password);
}

class ConfirmPasswordChanged extends SignUpEvent {
  String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class EmailChanged extends SignUpEvent {
  String email;
  EmailChanged(this.email);
}

class NombreChanged extends SignUpEvent {
  String nombre;
  NombreChanged(this.nombre);
}

class PupuseriaIdChanged extends SignUpEvent {
  String pupuseriaId;
  PupuseriaIdChanged(this.pupuseriaId);
}

class ToggleObscurePassword extends SignUpEvent {}

class ToggleObscureConfirmPassword extends SignUpEvent {}

class SignUpSubmitted extends SignUpEvent {}