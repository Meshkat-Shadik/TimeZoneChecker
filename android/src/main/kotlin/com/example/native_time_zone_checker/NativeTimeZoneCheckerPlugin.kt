package com.example.native_time_zone_checker

import android.content.ContentResolver
import android.database.ContentObserver
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Settings
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result


/** NativeTimeZoneCheckerPlugin */
class NativeTimeZoneCheckerPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {
  private lateinit var channel : MethodChannel
  private lateinit var eventChannel: EventChannel
  private var eventSink: EventChannel.EventSink? = null
  private lateinit var contentResolver: ContentResolver

  //for the very first time when the app is installed
  private fun checkAutoTimeSettings(): Boolean {
    val autoTime = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(contentResolver, Settings.Global.AUTO_TIME)
    } else {
      Settings.System.getInt(contentResolver, Settings.System.AUTO_TIME)
    }
    val autoTimeZone = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Settings.Global.getInt(contentResolver, Settings.Global.AUTO_TIME_ZONE)
    } else {
      Settings.System.getInt(contentResolver, Settings.System.AUTO_TIME_ZONE)
    }
    return autoTime == 1 && autoTimeZone == 1
  }

  //All the other times it is listening to the changes
  private val observer = object : ContentObserver(Handler(Looper.getMainLooper())) {
    override fun onChange(selfChange: Boolean) {
      Log.d("MainActivity", "onChange")
      val autoTime = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
        Log.d("MainActivity", "Ok Version 1 inside onChange")
        Settings.Global.getInt(contentResolver, Settings.Global.AUTO_TIME)
      } else {
        Settings.System.getInt(contentResolver, Settings.System.AUTO_TIME)
      }
      val autoTimeZone = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
        Log.d("MainActivity", "Ok Version 2 inside onChange")
        Settings.Global.getInt(contentResolver, Settings.Global.AUTO_TIME_ZONE)
      } else {
        Settings.System.getInt(contentResolver, Settings.System.AUTO_TIME_ZONE)
      }
      Log.d("MainActivity", "autoTime: $autoTime, autoTimeZone: $autoTimeZone")
      val bothEnabled = autoTime == 1 && autoTimeZone == 1
      eventSink?.success(bothEnabled)
    }
  }

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "native_time_zone_checker")
    channel.setMethodCallHandler(this)
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "com.example.native_time_zone_checker/event")
    eventChannel.setStreamHandler(this)
    contentResolver = flutterPluginBinding.applicationContext.contentResolver
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    Log.d("MainActivity", "onListen")
    eventSink = events
    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
      Log.d("MainActivity", "Ok Version")
      val bothEnabled = checkAutoTimeSettings()
      eventSink?.success(bothEnabled)
      contentResolver.registerContentObserver(Settings.Global.CONTENT_URI, true, observer)
    } else{
      val bothEnabled = checkAutoTimeSettings()
      eventSink?.success(bothEnabled)
      contentResolver.registerContentObserver(Settings.System.CONTENT_URI, true, observer)
    }
  }

  override fun onCancel(arguments: Any?) {
    Log.d("MainActivity", "onCancel")
    contentResolver.unregisterContentObserver(observer)
    eventSink = null
  }
}
