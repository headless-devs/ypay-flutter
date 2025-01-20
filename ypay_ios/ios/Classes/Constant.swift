import Foundation

enum Constants {
    static let pluginChannelName = "com.yandex.pay.flutter_channel/payment_methods";
    
    static let eventChannelName = "com.yandex.pay.flutter_channel/payment_events";
}

enum PaymentStatus: String {
    case success = "Finished with success"
    case cancelled = "Finished with cancelled event"
    case failed = "Finished with domain error"
    case unknown = "Finished when contract is null"
}