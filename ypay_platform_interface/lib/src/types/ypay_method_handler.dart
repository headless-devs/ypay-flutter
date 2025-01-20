import 'dart:convert';

import 'package:flutter/services.dart';

import '../../ypay_platform_interface.dart';

/// This class contains the necessary logic of the order of method calls
/// for the correct SDK working.
///
/// Platform implementations can use this class for platform calls.
class YPayMethodHandler {
  /// Initializes the SDK for further work.
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  Future<void> init({required Configuration configuration}) async {
    try {
      //ignore: unnecessary_null_comparison
      if (ServicesBinding.instance == null) {
        throw YPayInitializeError(
            message: 'Initialization error',
            data: 'Try to invoke \'WidgetsFlutterBinding.ensureInitialized()\' '
                'before initialization.');
      }
      await paymentChannel.invokeMethod('init', configuration.toMap());
    } on PlatformException catch (e) {
      throw YPayInitializeError(
        message: e.message ?? '',
        data: e.details ?? '',
      );
    }
  }

  /// The method to proceed to payment
  Future<void> startPayment({required String url}) async {
    try {
      await paymentChannel.invokeMethod('startPayment', url);
    } on PlatformException catch (e) {
      throw _convertPlatformExceptionToYPayError(e);
    }
  }

  YPayError _convertPlatformExceptionToYPayError(dynamic e) {
    final PlatformException exception = e;
    Map response;
    if (exception.message == null || exception.message == '') {
      return YPayInternalError(message: 'Empty or null error message', data: '');
    }
    try {
      response = jsonDecode(exception.message!);
    } on FormatException catch (e) {
      return YPayInternalError(message: e.message, data: '');
    } on Exception {
      return YPayInternalError(message: 'Data parsing error', data: '');
    }
    if (response.containsKey('type') && response.containsKey('data')) {
      final type = response['type'];
      final Map data = response['data'];
      switch (type) {
        case 'YPayError':
          switch (data['status']) {
            case 'ValidationError':
              return YPayValidationError(
                message: data['validationMessages'].toString(),
                data: data.toString(),
                code: '200',
              );
            default:
              return YPayInternalError(
                message: 'Unknown error status',
                data: data.toString(),
              );
          }
        case 'InternalError':
          return YPayInternalError(
            message: data['errorMessage'].toString(),
            data: data.toString(),
          );
        default:
          return YPayInternalError(
            message: 'Empty or unknown error type',
            data: data.toString(),
          );
      }
    } else {
      return YPayInternalError(
        message: 'Response does not contain the required keys',
        data: exception.message ?? 'Message is null',
      );
    }
  }
}
