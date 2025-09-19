//enum PasswordStatus { unknown, valid, invalid }
abstract class PasswordStatus {
  final String message;
  const PasswordStatus({this.message = ""});
}

class UnknownPasswordStatus extends PasswordStatus {
  const UnknownPasswordStatus({super.message});
}

class ValidPasswordStatus extends PasswordStatus {
  const ValidPasswordStatus({super.message});
}

class InvalidPasswordStatus extends PasswordStatus {
  const InvalidPasswordStatus({super.message});
}