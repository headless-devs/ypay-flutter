package com.yandex.pay.ypay_android

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class ChannelHolder {

    private val methodChannels = mutableListOf<MethodChannel>()
    private val eventChannels = mutableListOf<EventChannel>()

    fun add(channel: MethodChannel, handler: MethodChannel.MethodCallHandler) {
        channel.setMethodCallHandler(handler)
        methodChannels += channel
    }

    fun add(channel: EventChannel, handler: EventChannel.StreamHandler) {
        channel.setStreamHandler(handler)
        eventChannels += channel
    }

    fun clear() {
        methodChannels.forEach { it.setMethodCallHandler(null) }
        methodChannels.clear()

        eventChannels.forEach { it.setStreamHandler(null) }
        eventChannels.clear()
    }
}