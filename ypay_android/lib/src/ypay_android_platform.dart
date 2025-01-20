import 'package:ypay_platform_interface/ypay_platform_interface.dart';

/// An [YPayPlatform] that wraps YPay Android SDK.
class YPayAndroidPlatform extends YPayPlatform {
  YPayAndroidPlatform._();

  static final YPayMethodHandler _methodHandler = YPayMethodHandler();

  /// Registers this class as the default instance of [YPayPlatform].
  static void registerPlatform() {
    /// Register the platform instance with the plugin platform interface.
    YPayPlatform.instance = YPayAndroidPlatform._();
  }

  /// Initializes the SDK for further work.
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  @override
  Future<void> init({required Configuration configuration}) async {
    await _methodHandler.init(configuration: configuration);
  }

  /// Starts payment process.
  @override
  Future<void> startPayment({required String url}) async {
    await _methodHandler.startPayment(url: url);
  }

  /// Returns a [Stream] of payment results.
  ///
  /// The stream will emit a [String] value representing the payment result.
  @override
  Stream<String> paymentResultStream() => paymentEventChannel.receiveBroadcastStream().map((event) => event as String);
}
