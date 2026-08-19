/// Lightweight Either type used throughout the application.
/// Left represents failure, Right represents success.
sealed class Either<L, R> {
  const Either();

  /// Apply function based on the type.
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight);

  bool get isLeft => this is Left<L, R>;
  bool get isRight => this is Right<L, R>;
}

class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) => onLeft(value);
}

class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  T fold<T>(T Function(L l) onLeft, T Function(R r) onRight) => onRight(value);
}
