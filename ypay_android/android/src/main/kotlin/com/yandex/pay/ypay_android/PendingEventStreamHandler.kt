package com.yandex.pay.ypay_android

import io.flutter.plugin.common.EventChannel

class PendingEventStreamHandler : EventChannel.StreamHandler {

    private var pendingEvent: Any? = null
    private var events: EventChannel.EventSink? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        this.events = events

        pendingEvent?.let(events::success)
        pendingEvent = null
    }

    override fun onCancel(arguments: Any?) {
        clear()
    }

    fun send(event: Any) {
        val currentSink = events

        if (currentSink != null) {
            currentSink.success(event)
        } else {
            pendingEvent = event
        }
    }

    fun clear() {
        events = null
    }
}