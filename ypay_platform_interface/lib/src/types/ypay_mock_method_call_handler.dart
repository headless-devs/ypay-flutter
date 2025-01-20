import 'package:flutter/services.dart';

import '../errors/ypay_error.dart';

/// Mock platform channel method call handler.
Future ypayMockMethodCallHandler(MethodCall methodCall) async {
  switch (methodCall.method) {
    case 'init':
      final args = methodCall.arguments;
      final String merchantId = args['merchantId'];
      // final String merchantName = args['merchantName'];
      // final String merchantUrl = args['merchantUrl'];
      // final bool testMode = args['testMode'];

      if (merchantId.isEmpty) {
        throw YPayInitializeError(
          message: 'wrong configuration',
          data: '',
        );
      }

      return Future.value(true);
    case 'startPayment':
      final String url = methodCall.arguments;

      if (url.isEmpty) {
        throw PlatformException(
          message: '{"type":"YPayError","data":{"status":"ValidationError"'
              ',"validationMessages": [{ "message":"url is incorrect"},'
              '{"message":"url can not be empty"}]}}',
          code: '-1',
        );
      }
      return Future(() {});
  }
}
