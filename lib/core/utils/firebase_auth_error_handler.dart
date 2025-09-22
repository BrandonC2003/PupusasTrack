import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorHandler {
  static String getFriendlyErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'El correo electrónico ya está en uso. Por favor, utiliza otro.';
      
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      
      case 'user-not-found':
      case 'wrong-password':
        return 'Credenciales de acceso incorrectas.';
      
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada. Contacta con soporte.';
      
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Por favor, intenta más tarde.';
      
      case 'operation-not-allowed':
        return 'Esta operación no está permitida. Contacta con soporte.';
      
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu conexión a internet.';
      
      case 'requires-recent-login':
        return 'Esta operación requiere que inicies sesión nuevamente.';
      
      default:
        return 'Ocurrió un error inesperado, intenta nuevamente.';
    }
  }
  
  // Método para errores genéricos
  static String getGenericErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      return getFriendlyErrorMessage(error);
    } else {
      return 'Ocurrió un error inesperado, intenta nuevamente.';
    }
  }
}