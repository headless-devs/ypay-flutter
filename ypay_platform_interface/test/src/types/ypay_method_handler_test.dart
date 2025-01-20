import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_platform_interface/ypay_platform_interface.dart';

// ignore_for_file: unchecked_use_of_nullable_value
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late YPayMethodHandler handler;

  setUp(() {
    handler = YPayMethodHandler();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(paymentChannel, ypayMockMethodCallHandler);
  });

  tearDown(
    () {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(paymentChannel, null);
    },
  );

  test(
    'init()',
    () async {
      final completer = Completer<String>();

      const validConfig = Configuration(
        merchantUrl: 'merchantUrl',
        merchantId: 'merchantId',
        merchantName: 'merchantName',
      );

      await handler.init(configuration: validConfig).then((value) => completer.complete('initialized'));

      expect(completer.isCompleted, isTrue);
    },
  );

  test(
    'When config is invalid, init() calling should throws YPayException',
    () async {
      const invalidConfig = Configuration(
        merchantUrl: '',
        merchantId: '',
        merchantName: '',
      );

      expect(() async => handler.init(configuration: invalidConfig), throwsA(isA<YPayInitializeError>()));
    },
  );
  test(
    'startPayment()',
    () async {
      final completer = Completer<void>();
      const validURL = 'https://example.com';

      await handler.startPayment(url: validURL).then((value) => completer.complete());

      expect(completer.isCompleted, isTrue);
    },
  );
  test(
    'When url is invalid, startPayment() calling should throws YPayException',
    () async {
      const invalidURL = '';
      expect(() async => handler.startPayment(url: invalidURL), throwsA(isA<YPayValidationError>()));
    },
  );
}
