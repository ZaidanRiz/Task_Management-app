package com.example.task_management_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import android.os.Build
import android.os.PowerManager
import android.app.AlarmManager

class MainActivity: FlutterActivity() {
	private val channelName = "app.settings"

	override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
		super.configureFlutterEngine(flutterEngine)

		MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName)
			.setMethodCallHandler { call, result ->
				when (call.method) {
					"openAppDetails" -> {
						try {
							SettingsIntents.openAppDetails(this)
							result.success(true)
						} catch (e: Exception) {
							result.error("OPEN_FAILED", e.message, null)
						}
					}
					"openAppNotificationSettings" -> {
						try {
							SettingsIntents.openAppNotificationSettings(this)
							result.success(true)
						} catch (e: Exception) {
							result.error("OPEN_FAILED", e.message, null)
						}
					}
					"openExactAlarmSettings" -> {
						try {
							SettingsIntents.openExactAlarmSettings(this)
							result.success(true)
						} catch (e: Exception) {
							result.error("OPEN_FAILED", e.message, null)
						}
					}
					"openIgnoreBatteryOptimizations" -> {
						try {
							SettingsIntents.openIgnoreBatteryOptimizations(this)
							result.success(true)
						} catch (e: Exception) {
							result.error("OPEN_FAILED", e.message, null)
						}
					}
					"isExactAlarmsAllowed" -> {
						try {
							if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
								val alarmManager = getSystemService(AlarmManager::class.java)
								result.success(alarmManager.canScheduleExactAlarms())
							} else {
								result.success(true)
							}
						} catch (e: Exception) {
							result.success(false)
						}
					}
					"isIgnoringBatteryOptimizations" -> {
						try {
							val pm = getSystemService(PowerManager::class.java)
							result.success(pm.isIgnoringBatteryOptimizations(packageName))
						} catch (e: Exception) {
							result.success(false)
						}
					}
					else -> result.notImplemented()
				}
			}
	}
}
