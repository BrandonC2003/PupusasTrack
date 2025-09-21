import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

import '../../domain/entities/auth_user.dart';

class AuthUserModel extends AuthUser {

  AuthUserModel({
    required super.id,
    required super.email,
    super.name,
    super.photoURL,
    super.idPupuseria
  });

  factory AuthUserModel.fromFirebaseAuthUser(
    firebase_auth.User firebaseUser,
  ) {
    return AuthUserModel(
      id: firebaseUser.uid,
      email: firebaseUser.email ?? '',
      name: firebaseUser.displayName,
      photoURL: firebaseUser.photoURL,
    );
  }
}