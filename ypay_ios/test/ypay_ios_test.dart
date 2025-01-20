import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_ios/ypay_ios.dart';
import 'package:ypay_ios/src/ypay_ios_platform.dart';
import 'package:ypay_platform_interface/ypay_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    YPayIosPlatform.registerPlatform();
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

      await YPayPlatform.instance.init(configuration: validConfig).then((value) => completer.complete('initialized'));

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

      expect(() async => YPayPlatform.instance.init(configuration: invalidConfig), throwsA(isA<YPayInitializeError>()));
    },
  );
  test(
    'startPayment()',
    () async {
      final completer = Completer<void>();
      const validURL = 'https://example.com';

      await YPayPlatform.instance.startPayment(url: validURL).then((value) => completer.complete());

      expect(completer.isCompleted, isTrue);
    },
  );
  test(
    'When url is invalid, startPayment() calling should throws YPayException',
    () async {
      const invalidURL = '';
      expect(() async => YPayPlatform.instance.startPayment(url: invalidURL), throwsA(isA<YPayValidationError>()));
    },
  );
}
