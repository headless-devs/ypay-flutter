import '../ypay_platform_interface.dart';

/// The interface that implementations of 'YPay' must implement.
///
/// Platform implementations should extend this class rather than implement it
/// as `YPay` does not consider newly added methods to be breaking changes.
/// Extending this class(using `extends`) ensures that the subclass will get the
/// default implementation, while platform implementations that `implements`
/// this interface will be broken by newly added [YPayPlatform] methods.
abstract class YPayPlatform {
  /// Should only be accessed after setter is called.
  static late YPayPlatform _instance;

  /// Platform-specific plugins should set this with their own platform-specific
  /// class that extends [YPayPlatform] when they register themselves.
  // ignore: unnecessary_getters_setters
  static set instance(YPayPlatform instance) {
    _instance = instance;
  }

  /// The instance of [YPayPlatform] to use.
  ///
  /// Must be set before accessing.
  // ignore: unnecessary_getters_setters
  static YPayPlatform get instance => _instance;

  /// Initializes the SDK for further work
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  Future<void> init({required Configuration configuration}) => throw UnimplementedError('init() has not been implemented.');

  /// Starts a payment with a specific payment method.
  ///
  /// The [url] parameter is the payment method specific URL.
  ///
  /// Throws a [PlatformException] if there is an error during the payment process.
  ///
  /// Returns a [Future] that completes when the payment is finished.
  /// The result of the future is a [void] value.
  Future<void> startPayment({required String url}) => throw UnimplementedError('startPayment() has not been implemented.');

  /// Returns stream of payment result.
  ///
  /// The stream emits strings which represent payment result events.
  /// The events are payment result events, such as success, cancelled, or failure.
  ///
  /// The events are received as strings, with the format:
  /// - "Finished with success: {orderId}"
  /// - "Finished with cancelled event"
  /// - "Finished with domain error: {errorMsg}"
  ///
  /// Example usage:
  /// ```dart
  /// paymentEventChannel.receiveBroadcastStream().listen((event) {
  ///   switch (event) {
  ///     case "Finished with success: {orderId}":
  ///       // Handle success
  ///       break;
  ///     case "Finished with cancelled event":
  ///       // Handle cancelled
  ///       break;
  ///     case "Finished with domain error: {errorMsg}":
  ///       // Handle domain error
  ///       break;
  ///   }
  /// });
  /// ```
  Stream<String> paymentResultStream() => throw UnimplementedError('paymentResultStream() has not been implemented.');
}
