//enum PasswordStatus { unknown, valid, invalid }
abstract class PupuseriaIdStatus {
  final String message;
  const PupuseriaIdStatus({this.message = ""});
}

class UnknownPupuseriaIdStatus extends PupuseriaIdStatus {
  const UnknownPupuseriaIdStatus({super.message});
}

class ValidPupuseriaIdStatus extends PupuseriaIdStatus {
  const ValidPupuseriaIdStatus({super.message});
}

class InvalidPupuseriaIdStatus extends PupuseriaIdStatus {
  const InvalidPupuseriaIdStatus({super.message});
}