/// Failure types for use across the domain/data layers.
abstract class Failure {
  final String message;
  Failure(this.message);

  @override
  String toString() => message;
}

class ServerFailure extends Failure {
  ServerFailure(super.message);
}

class ValidationFailure extends Failure {
  ValidationFailure(super.message);
}

class CacheFailure extends Failure {
  CacheFailure(super.message);
}
