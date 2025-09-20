import 'package:pupusas_track/features/auth/presentation/blocs/confirmar_password_status.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/nombre_status.dart';
import 'package:pupusas_track/features/auth/presentation/blocs/pupuseria_id_status.dart';

import '../email_status.dart';
import '../form_status.dart';
import '../password_status.dart';

class SignUpState {
  //Datos del formulario
  final String? email;
  final String? password;
  final String? confirmPassword;
  final String? nombre;
  final String? idPupuseria;
  final bool obscurePassword;
  final bool obscureConfirmPassword;

  //Estados
  final EmailStatus emailStatus;
  final PasswordStatus passwordStatus;
  final ConfirmarPasswordStatus confirmarPasswordStatus;
  final NombreStatus nombreStatus;
  final PupuseriaIdStatus idPupuseriaStatus;
  final FormStatus formStatus;

  const SignUpState({
    this.email,
    this.password,
    this.confirmPassword,
    this.nombre,
    this.idPupuseria,
    this.obscurePassword = true,
    this.obscureConfirmPassword = true,
    this.emailStatus = const UnknownEmailStatus(),
    this.passwordStatus = const UnknownPasswordStatus(),
    this.confirmarPasswordStatus = const UnknownConfirmarPasswordStatus(),
    this.nombreStatus = const UnknownNombreStatus(),
    this.idPupuseriaStatus = const UnknownPupuseriaIdStatus(),
    this.formStatus = const InitialFormStatus(),
  });

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? nombre,
    String? idPupuseria,
    bool? obscurePassword,
    bool? obscureConfirmPassword,
    EmailStatus? emailStatus,
    PasswordStatus? passwordStatus,
    ConfirmarPasswordStatus? confirmarPasswordStatus,
    NombreStatus? nombreStatus,
    PupuseriaIdStatus? idPupuseriaStatus,
    FormStatus? formStatus,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      nombre: nombre ?? this.nombre,
      idPupuseria: idPupuseria ?? this.idPupuseria,
      obscurePassword: obscurePassword ?? this.obscurePassword,
      obscureConfirmPassword: obscureConfirmPassword ?? this.obscureConfirmPassword,
      emailStatus: emailStatus ?? this.emailStatus,
      passwordStatus: passwordStatus ?? this.passwordStatus,
      confirmarPasswordStatus: confirmarPasswordStatus ?? this.confirmarPasswordStatus,
      nombreStatus: nombreStatus ?? this.nombreStatus,
      idPupuseriaStatus: idPupuseriaStatus ?? this.idPupuseriaStatus,
      formStatus: formStatus ?? this.formStatus,
    );
  }
}