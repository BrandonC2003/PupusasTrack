/// Lightweight Result type to return success or failure without throwing.
/// Usage: return Result.ok(value) or Result.err(error)
class Result<T, E> {
  final T? value;
  final E? error;
  const Result._({this.value, this.error});

  bool get isOk => error == null;
  bool get isErr => !isOk;

  factory Result.ok(T v) => Result._(value: v);
  factory Result.err(E e) => Result._(error: e);

  R when<R>({required R Function(T) ok, required R Function(E) err}) {
    if (isOk) return ok(value as T);
    return err(error as E);
  }
}
