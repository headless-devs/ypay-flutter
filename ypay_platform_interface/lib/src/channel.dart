import 'package:flutter/services.dart';

/// A constant [MethodChannel] for invoking payment methods.
///
/// This channel is used to invoke payment methods from the Yandex Pay SDK.
/// The methods are used to start payment with a specific payment method.
///
/// The methods are called with the following format:
/// - "startPayment": starts a payment with a specific payment method.
///   - Parameters:
///     - [url]: the payment method specific URL.
///   - Returns: nothing, but sends a payment result event through the
///     [paymentEventChannel] if the payment is finished.
const MethodChannel paymentChannel = MethodChannel('com.yandex.pay.flutter_channel/payment_methods');

/// A constant [EventChannel] for listening to payment events.
///
/// This channel is used to receive events from the Yandex Pay SDK.
/// The events are payment result events, such as success, cancelled, or failure.
///
/// The events are received as strings, with the format:
/// - "Finished with success: {orderId}"
/// - "Finished with cancelled event"
/// - "Finished with domain error: {errorMsg}"
///
/// Example usage:
const EventChannel paymentEventChannel = EventChannel('com.yandex.pay.flutter_channel/payment_events');
