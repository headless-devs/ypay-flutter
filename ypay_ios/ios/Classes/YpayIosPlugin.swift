import Flutter
import UIKit
import YandexPaySDK


public class YpayIosPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel
    private var eventChannel: FlutterEventChannel
    private var eventSink: FlutterEventSink?
    private var form: YandexPayForm?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: Constants.pluginChannelName, binaryMessenger: registrar.messenger())
        let eventChannel = FlutterEventChannel(name: Constants.eventChannelName, binaryMessenger: registrar.messenger())
        let instance = YpayIosPlugin(channel: channel, eventChannel: eventChannel)

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
        eventChannel.setStreamHandler(instance)
    }

    init(channel: FlutterMethodChannel, eventChannel: FlutterEventChannel) {
        self.channel = channel
        self.eventChannel = eventChannel
        super.init()
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "init":
            handleInit(call: call, result: result)
        case "startPayment":
            handleStartPayment(call: call, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    private func handleInit(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard let arguments = call.arguments as? [String: Any],
              let merchantId = arguments["merchantId"] as? String,
              let merchantUrl = arguments["merchantUrl"] as? String,
              let merchantName = arguments["merchantName"] as? String,
              let testMode = arguments["testMode"] as? Bool else {
            result(FlutterError(code: "-1", message: "Wrong argument type", details: nil))
            return
        }
        
        let environment = testMode ? YandexPaySDKEnvironment.sandbox : YandexPaySDKEnvironment.production
        do {
            let merchant = YandexPaySDKMerchant(id: merchantId, name: merchantName, url: merchantUrl)
            let config = YandexPaySDKConfiguration(environment: environment, merchant: merchant, locale: .ru)
            try YandexPaySDKApi.initialize(configuration: config)
            result("YandexPaySDKApi initialized")
        } catch let error {
            result(FlutterError(code: "-1", message: error.localizedDescription, details: nil))
        }
    }

    private func handleStartPayment(call: FlutterMethodCall, result: @escaping FlutterResult) {
        guard YandexPaySDKApi.isInitialized else {
            result(FlutterError(code: "-1", message: "YandexPaySDKApi is not initialized", details: nil))
            return
        }
        guard let paymentURL = call.arguments as? String else {
            result(FlutterError(code: "-1", message: "Wrong argument type", details: nil))
            return
        }

        DispatchQueue.main.async {
            self.startPayment(paymentURL: paymentURL, result: result)
        }
    }

    private func startPayment(paymentURL: String, result: @escaping FlutterResult) {
        guard let rootViewController = UIApplication.shared.delegate?.window??.rootViewController else {
            result(FlutterError(code: "-1", message: "Unable to get root view controller", details: nil))
            return
        }

        self.form = YandexPaySDKApi.instance.createYandexPayForm(paymentURL: paymentURL, delegate: self)

        guard let form = self.form else {
            result(FlutterError(code: "-1", message: "Failed to create YandexPay form", details: nil))
            return
        }

        form.present(from: rootViewController, animated: true, completion: nil)  
    }
}

extension YpayIosPlugin: FlutterStreamHandler {
    public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
    
    private func sendEvent(_ event: PaymentStatus, errorMsg: String? = nil) {
        if let errorMsg = errorMsg {
            eventSink?("\(event.rawValue): \(errorMsg)")
        } else {
            eventSink?(event.rawValue)
        }
    }
}

extension YpayIosPlugin: YandexPayFormDelegate {
    public func yandexPayForm(_ form: YandexPaySDK.YandexPayForm, data: YandexPaySDK.YPYandexPayPaymentData, didCompletePaymentWithResult result: YandexPaySDK.YPYandexPayPaymentResult) {
        switch result {
            case .succeeded:
                sendEvent(.success)
            case .cancelled:
                sendEvent(.cancelled)
            case .failed(let error):
                sendEvent(.failed, errorMsg: error.localizedDescription)
            @unknown default:
                sendEvent(.unknown)
        }
    }
}