import 'package:dartz/dartz.dart';
import 'package:learning/core/error/failures.dart';

/// Base interface for all use cases in the application
///
/// [T] is the return type of the use case
/// [P] is the input parameters type
abstract class UseCase<T, P> {
  Future<Either<Failure, T>> call(P params);
}

/// Use this class when a use case doesn't need any parameters
class NoParams {
  const NoParams();
}
