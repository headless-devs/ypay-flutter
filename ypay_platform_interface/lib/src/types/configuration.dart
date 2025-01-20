/// The class represents the information for SDK initialization.
class Configuration {
  /// Constructs a Configuration.
  const Configuration({
    required this.merchantId,
    required this.merchantName,
    required this.merchantUrl,
    this.testMode = true,
  });

  /// Unique identifier of the merchant.
  ///
  /// It can be obtained when registering the merchant in the Yandex Pay service
  /// [https://pay.yandex.ru/ru/docs/console/settings#merchant-id]
  final String merchantId;

  /// URL of the merchant, which will be displayed to the user.
  final String merchantUrl;

  /// Name of the merchant, which will be displayed to the user.
  final String merchantName;

  /// The environment of the Yandex Pay SDK.
  ///
  /// `true` - SANDBOX environment (test)
  ///
  /// `false` - PRODUCTION environment (prod)
  final bool testMode;

  /// Returns map of parameters
  Map<String, dynamic> toMap() => {
        'merchantId': merchantId,
        'merchantUrl': merchantUrl,
        'merchantName': merchantName,
        'testMode': testMode,
      };

  @override
  String toString() {
    return 'YPayConfig{merchantId: $merchantId, merchantUrl: $merchantUrl, merchantName: $merchantName, testMode: $testMode}';
  }
}
