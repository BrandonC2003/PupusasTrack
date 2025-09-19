import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? photoURL;
  final String? idPupuseria; // ID de la pupusería asociada al usuario

  const AuthUser({
    required this.id,
    required this.email,
    this.name,
    this.photoURL,
    this.idPupuseria,
  });

  static const AuthUser empty = AuthUser(
    id: '',
    name: '',
    email: '',
    photoURL: '',
    idPupuseria: '',
  );

  bool get isEmpty => this == AuthUser.empty;

  @override
  List<Object?> get props => [id, name, email, photoURL, idPupuseria];
}