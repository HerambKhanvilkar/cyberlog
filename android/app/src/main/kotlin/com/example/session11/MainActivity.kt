package com.example.session11

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build

class MainActivity : FlutterActivity() {

    private val CHANNEL = "device_info_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            when (call.method) {
                "getDeviceModel" -> {
                    val model = Build.MODEL
                    result.success(model)
                }
                "getAndroidVersion" -> {
                    val version = Build.VERSION.RELEASE
                    result.success(version)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}