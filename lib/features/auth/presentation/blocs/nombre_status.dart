abstract class NombreStatus {
  final String message;
  const NombreStatus({this.message = ""});
}

class UnknownNombreStatus extends NombreStatus {
  const UnknownNombreStatus({super.message});
}

class ValidNombreStatus extends NombreStatus {
  const ValidNombreStatus({super.message});
}

class InvalidNombreStatus extends NombreStatus {
  const InvalidNombreStatus({super.message});
}