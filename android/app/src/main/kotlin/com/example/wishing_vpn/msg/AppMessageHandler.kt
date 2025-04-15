package com.example.wishing_vpn.msg

import android.util.Log
import com.google.gson.Gson
import io.flutter.plugin.common.EventChannel

class AppMessageHandler: EventChannel.StreamHandler  {
  private var sink: EventChannel.EventSink? = null

  private val gson = Gson()

  private val omissionEvents = mutableListOf<Any>()

  override fun onListen(
    arguments: Any?,
    events: EventChannel.EventSink?,
  ) {
    Log.d("EVENT", "sink bind finish")
    sink = events
    if (omissionEvents.isNotEmpty()) {
      omissionEvents.forEach {
        sink?.success(gson.toJson(it))
      }
      omissionEvents.clear()
    }
  }

  override fun onCancel(arguments: Any?) {
  }

  fun send(any: Any) {
    var msg = gson.toJson(any)
    Log.d("EVENT", "send $msg ${sink == null}")
    if (sink == null) {
      omissionEvents.add(any)
    } else {
      sink?.success(msg)
    }
  }
}