abstract class EmailStatus {
  final String message;
  const EmailStatus({this.message = ""});
}

class UnknownEmailStatus extends EmailStatus {
  const UnknownEmailStatus({super.message});
}

class ValidEmailStatus extends EmailStatus {
  const ValidEmailStatus({super.message});
}

class InvalidEmailStatus extends EmailStatus {
  const InvalidEmailStatus({super.message});
}