//enum PasswordStatus { unknown, valid, invalid }
abstract class ConfirmarPasswordStatus {
  final String message;
  const ConfirmarPasswordStatus({this.message = ""});
}

class UnknownConfirmarPasswordStatus extends ConfirmarPasswordStatus {
  const UnknownConfirmarPasswordStatus({super.message});
}

class ValidConfirmarPasswordStatus extends ConfirmarPasswordStatus {
  const ValidConfirmarPasswordStatus({super.message});
}

class InvalidConfirmarPasswordStatus extends ConfirmarPasswordStatus {
  const InvalidConfirmarPasswordStatus({super.message});
}