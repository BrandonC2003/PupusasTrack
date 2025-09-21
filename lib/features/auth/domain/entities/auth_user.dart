class AuthUser {
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

  AuthUser copyWith({
    String? id,
    String? email,
    String? name,
    String? photoURL,
    String? idPupuseria
  }){
    return AuthUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      photoURL: photoURL ?? this.photoURL,
      idPupuseria: idPupuseria ?? this.idPupuseria
    );
  }

  static const AuthUser empty = AuthUser(
    id: '',
    name: '',
    email: '',
    photoURL: '',
    idPupuseria: '',
  );

  bool get isEmpty => this == AuthUser.empty;
}