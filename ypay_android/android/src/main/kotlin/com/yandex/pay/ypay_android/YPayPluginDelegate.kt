package com.yandex.pay.ypay_android

import android.content.Context
import android.content.Intent
import androidx.activity.ComponentActivity
import com.yandex.pay.PaymentSession
import com.yandex.pay.YPay
import com.yandex.pay.YPayConfig
import com.yandex.pay.YPayContract
import com.yandex.pay.YPayContractParams
import com.yandex.pay.YPayResult
import com.yandex.pay.YPayLauncher
import io.flutter.plugin.common.MethodCall
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry
import android.util.Log
import com.yandex.pay.CurrencyCode
import com.yandex.pay.MerchantData
import com.yandex.pay.MerchantId
import com.yandex.pay.MerchantName
import com.yandex.pay.MerchantUrl
import com.yandex.pay.Metadata
//import com.yandex.pay.PaymentCart
import com.yandex.pay.PaymentData
//import com.yandex.pay.PaymentType
//import com.yandex.pay.Product
//import com.yandex.pay.Quantity
import com.yandex.pay.YPayApiEnvironment

object YPayPluginDelegate : PluginRegistry.ActivityResultListener {

    private const val LAUNCH_PAYMENT_METHOD_NAME = "startPayment"
    private const val CONFIG_PAYMENT_METHOD_NAME = "init"
    private const val START_PAYMENT_REQUEST_CODE = 1

    private val channels = ChannelHolder()

    private val methodCallHandler = MethodChannel.MethodCallHandler { call, result ->
        when (call.method) {
            LAUNCH_PAYMENT_METHOD_NAME -> startPayment(call, result)
            CONFIG_PAYMENT_METHOD_NAME -> configPayment(call, result)
            else -> result.notImplemented()
        }
    }
    private val eventStreamHandler = PendingEventStreamHandler()

    private var config: YPayConfig? = null
    private var paymentContract: YPayContract? = null
    private var activityBinding: ActivityPluginBinding? = null

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?): Boolean {
        return when (requestCode) {
            START_PAYMENT_REQUEST_CODE -> {
                onPaymentResult(resultCode, data)
                true
            }

            else -> false
        }
    }

    fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channels.add(
            MethodChannel(binding.binaryMessenger, YpayAndroidPlugin.METHOD_CHANNEL_NAME),
            methodCallHandler,
        )
        channels.add(
            EventChannel(binding.binaryMessenger, YpayAndroidPlugin.EVENT_CHANNEL_NAME),
            eventStreamHandler,
        )
    }

    fun onDetachedFromEngine() {
        eventStreamHandler.clear()
        channels.clear()
    }

    fun setActivityBinding(binding: ActivityPluginBinding?) {
        activityBinding?.removeActivityResultListener(this)
        activityBinding = binding
        activityBinding?.addActivityResultListener(this)

        val act = activityBinding?.activity as? FlutterFragmentActivity
        act?.let {
            paymentContract = YPayContract(it)

        }
    }

    private var yandexPayLauncher: YPayLauncher? = null
    private fun configPayment(call: MethodCall, result: MethodChannel.Result) {
        if (call.arguments is HashMap<*, *>) {
            val args = call.arguments as HashMap<*, *>
            val merchantId: String = args["merchantId"] as String
            val merchantName: String = args["merchantName"] as String
            val merchantUrl: String = args["merchantUrl"] as String
            val testMode: Boolean = args["testMode"] as Boolean
            config = YPayConfig(
                merchantData = MerchantData(
                    MerchantId(merchantId),
                    MerchantName(merchantName),
                    MerchantUrl(merchantUrl),
                ),
                environment = if (testMode) YPayApiEnvironment.SANDBOX else YPayApiEnvironment.PROD,
            )
            result.success("initialized")
        } else {
            result.error("-1", "Initialization error", "Wrong argument type")
        }
    }

    private fun startPayment(call: MethodCall, result: MethodChannel.Result) {
        val activity = activityBinding?.activity
        val contract = paymentContract
        if (activity == null || contract == null) {
            result.error("errorNoActivity", null, null)
            return
        }
        if (contract == null) {
            result.error("errorNoContract", null, null)
            return
        }
        var paymentData: PaymentData? = null
        if (call.arguments is String) {
            val url: String = call.arguments as String
            paymentData = PaymentData.PaymentUrlFlowData(url);
        } else {
            result.error("-1", "Initialization error", "Wrong argument type")
        }
        val params = YPayContractParams(
            getPaymentSession(activity.applicationContext),
            paymentData as PaymentData
        )
        contract
            .createIntent(activity, params)
            .also { intent -> activity.startActivityForResult(intent, START_PAYMENT_REQUEST_CODE) }
        result.success(null)
    }

    private fun onPaymentResult(resultCode: Int, data: Intent?) {
        val flutterRes =
            when (val result: YPayResult? = paymentContract?.parseResult(resultCode, data)) {
                null -> "Finished when contract is null"
                is YPayResult.Success -> "Finished with success: ${result.orderId.value}"
                is YPayResult.Cancelled -> "Finished with cancelled event"
                is YPayResult.Failure -> "Finished with domain error: ${result.errorMsg}"
            }
        eventStreamHandler.send(flutterRes)
    }

    private fun getPaymentSession(context: Context): PaymentSession {
        return YPay.getYandexPaymentSession(
            context.applicationContext,
            config as YPayConfig,
        )
    }

}