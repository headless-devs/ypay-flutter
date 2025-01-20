package com.yandex.pay.ypay_android

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class YpayAndroidPlugin : FlutterPlugin, ActivityAware {

    private val pluginDelegate: YPayPluginDelegate = YPayPluginDelegate

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginDelegate.onAttachedToEngine(binding)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        pluginDelegate.onDetachedFromEngine()
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        pluginDelegate.setActivityBinding(binding)
    }

    override fun onDetachedFromActivityForConfigChanges() {
        pluginDelegate.setActivityBinding(null)
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        pluginDelegate.setActivityBinding(binding)
    }

    override fun onDetachedFromActivity() {
        pluginDelegate.setActivityBinding(null)
    }

    companion object {
        const val METHOD_CHANNEL_NAME = "com.yandex.pay.flutter_channel/payment_methods"
        const val EVENT_CHANNEL_NAME = "com.yandex.pay.flutter_channel/payment_events"
    }
}
