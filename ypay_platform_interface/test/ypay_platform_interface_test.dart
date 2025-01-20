import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_platform_interface/ypay_platform_interface.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('$YPayPlatform', () {
    test('Can be extended', () {
      YPayPlatform.instance = ExtendsYPayPlatform();
    });

    final ExtendsYPayPlatform yPayPlatform = ExtendsYPayPlatform();

    test(
        'Default implementation of init()'
        'should throw unimplemented error', () {
      expect(
        () => yPayPlatform.init(
            configuration: const Configuration(
          merchantId: 'merchantId',
          merchantName: 'merchantName',
          merchantUrl: 'merchantUrl',
        )),
        throwsUnimplementedError,
      );
    });
    test(
        'Default implementation of startPayment()'
        'should throw unimplemented error', () {
      expect(
        () => yPayPlatform.startPayment(url: 'testUrl'),
        throwsUnimplementedError,
      );
    });
  });
}

class ExtendsYPayPlatform extends YPayPlatform {}
