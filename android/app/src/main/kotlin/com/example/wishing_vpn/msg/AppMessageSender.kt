package com.example.wishing_vpn.msg

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch

object AppMessageSender {
  private var eventChannel: EventChannel? = null
  private var eventChannelHandler: AppMessageHandler? = null

  fun init(messenger: BinaryMessenger) {
    eventChannel = EventChannel(messenger, "wishing.event")
    eventChannelHandler = AppMessageHandler()
    eventChannel?.setStreamHandler(eventChannelHandler)
  }

  fun send(event: AppMessage) {
    GlobalScope.launch(Dispatchers.Main) {
      try {
        eventChannelHandler?.send(event)
      } catch (_: Exception) {

      }
    }
  }

  fun dipsose() {
    eventChannel = null
    eventChannelHandler = null
  }
}