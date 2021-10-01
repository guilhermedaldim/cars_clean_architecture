import 'package:equatable/equatable.dart';

class Failure extends Equatable implements Exception {
  const Failure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class HttpError extends Failure {
  const HttpError(String message) : super(message);
}

class ServerError extends Failure {
  const ServerError(String message) : super(message);
}

class CacheError extends Failure {
  const CacheError(String message) : super(message);
}
