package com.example.wishing_vpn.msg

import androidx.annotation.Keep

@Keep
open class AppMessage(val name: String)

@Keep
data class RouteEvent(val op: String, val target: String, val argument: String? = null) :
  AppMessage(name = "route_event") {
  companion object FACTORY {
    fun restart(): RouteEvent = RouteEvent("restart", "/start")

    fun activityLifecycle(activityName: String, lifecycleName: String) =
      RouteEvent("activity_lifecycle", "", lifecycleName)
  }
}