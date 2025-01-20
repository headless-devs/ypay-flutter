import 'package:flutter/foundation.dart';
import 'package:ypay_android/ypay_android.dart';
import 'package:ypay_ios/ypay_ios.dart';
import 'package:ypay_platform_interface/ypay_platform_interface.dart';

import 'ypay_contract/ypay_contract.dart';
export 'package:ypay_platform_interface/ypay_platform_interface.dart';
export 'ypay_contract/ypay_contract.dart';

/// Basic YPay API.
class YPay {
  YPay._();

  static YPay? _instance;

  /// The instance of the [YPay] to use.
  static YPay get instance => _getOrCreateInstance();

  /// Returns the instance of the [YPay] to use.
  ///
  /// You can use this function to get the instance of the [YPay] class.
  /// It will create a new instance if it doesn't exist yet.
  ///
  /// Returns:
  ///   A [YPay] instance.
  static YPay _getOrCreateInstance() {
    if (_instance != null) {
      return _instance!;
    }

    if (defaultTargetPlatform == TargetPlatform.android) {
      YPayAndroidPlatform.registerPlatform();
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      YPayIosPlatform.registerPlatform();
    }

    _instance = YPay._();
    return _instance!;
  }

  /// Initializes the SDK for further work.
  ///
  /// You can call this method multiple times to set new configuration params.
  /// Read more about [Configuration] parameter.
  Future<void> init({required Configuration configuration}) {
    return YPayPlatform.instance.init(configuration: configuration);
  }

  /// Returns a [Stream] of payment results.
  ///
  /// The stream will emit a [String] value representing the payment result.
  Stream<String> paymentResultStream() => YPayPlatform.instance.paymentResultStream();

  /// The method to proceed to payment
  void startPayment({required String url}) {
    YPayPlatform.instance.startPayment(url: url);
  }

  /// Метод для создания контракта
  YPayContract createContract({
    required String url,
    required YPayTransactionCallback onStatusChange,
  }) =>
      YPayContract(url: url, ypay: this, onStatusChange: onStatusChange);
}
