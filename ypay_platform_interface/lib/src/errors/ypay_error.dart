/// YPay error.
abstract class YPayError implements Exception {
  /// Constructs a YPayError.
  YPayError({
    required this.message,
    required this.data,
  });

  /// Contains error message.
  final String message;

  /// Contains error data.
  final String data;

  @override
  String toString() {
    return '$message\n$data';
  }
}

/// Initialization error.
class YPayInitializeError extends YPayError {
  /// Constructs a YPayInitializeError.
  YPayInitializeError({
    required String message,
    required String data,
  }) : super(message: message, data: data);
}

/// Client error.
class YPayValidationError extends YPayError {
  /// Constructs a YPayValidationError.
  YPayValidationError({
    required String message,
    required String data,
    required this.code,
  }) : super(message: message, data: data);

  /// Contains error code.
  final String code;
}

/// Internal error.
class YPayInternalError extends YPayError {
  /// Constructs a YPayInternalError.
  YPayInternalError({
    required String message,
    required String data,
  }) : super(message: message, data: data);
}

/// Unknown error.
class YPayUnknownError extends YPayError {
  /// Constructs a YPayUnknownError.
  YPayUnknownError({
    required String message,
    required String data,
  }) : super(message: message, data: data);
}
