import 'package:flutter_test/flutter_test.dart';
import 'package:ypay_platform_interface/src/types/configuration.dart';

void main() {
  test('Constructor Test', () {
    // Arrange
    const configuration = Configuration(
      merchantUrl: 'merchantUrl',
      merchantId: 'merchantId',
      merchantName: 'merchantName',
      testMode: false,
    );

    // Assert
    expect(configuration.merchantId, 'merchantId');
    expect(configuration.merchantUrl, 'merchantUrl');
    expect(configuration.merchantName, 'merchantName');
    expect(configuration.testMode, false);
  });
}
