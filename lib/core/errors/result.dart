import 'failures.dart';

/// Dart sealed class equivalent of Kotlin's Result<T>.
/// Use [Result.success] or [Result.failure] to create instances.
sealed class Result<T> {
  const Result();

  const factory Result.success(T data) = Success<T>;
  const factory Result.failure(Failure failure) = Failure_<T>;

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure_<T>;

  T? get dataOrNull => switch (this) {
        Success<T>(data: final d) => d,
        Failure_<T>() => null,
      };

  Failure? get failureOrNull => switch (this) {
        Success<T>() => null,
        Failure_<T>(failure: final f) => f,
      };

  /// Execute [onSuccess] or [onFailure] based on the result.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) =>
      switch (this) {
        Success<T>(data: final d) => onSuccess(d),
        Failure_<T>(failure: final f) => onFailure(f),
      };
}

final class Success<T> extends Result<T> {
  final T data;
  const Success(this.data);
}

final class Failure_<T> extends Result<T> {
  final Failure failure;
  const Failure_(this.failure);
}
