import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';

class NotificationService {
  NotificationService._internal();
  static final NotificationService instance = NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  // In-app fallback timers (only work while the app process is alive).
  final Map<int, Timer> _fallbackTimers = <int, Timer>{};
  final Map<int, DateTime> _scheduledAt = <int, DateTime>{};

  static const String _channelId = 'tasks_channel_v2';
  static const String _channelName = 'Task Reminders';

  AndroidNotificationDetails _androidDetails() {
    return const AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: 'Reminders for your tasks',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      visibility: NotificationVisibility.public,
      category: AndroidNotificationCategory.alarm,
    );
  }

  Future<void> init() async {
    if (_initialized) return;

    // Timezone
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
    debugPrint('[Notif] Timezone: $timeZoneName');

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);

    // Channel
    if (Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      await androidPlugin?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          _channelName,
          description: 'Reminders for your tasks',
          importance: Importance.max,
          playSound: true,
          enableVibration: true,
          enableLights: true,
        ),
      );
    }

    // Permission Android 13+
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (!status.isGranted) {
        final res = await Permission.notification.request();
        debugPrint('[Notif] Notification permission result: $res');
      } else {
        debugPrint('[Notif] Notification permission already granted');
      }
    }

    _initialized = true;
  }

  Future<void> showNow({
    required int id,
    required String title,
    required String body,
  }) async {
    debugPrint('[Notif] showNow id=$id title=$title body=$body');
    await _plugin.show(
      id,
      title,
      body,
      NotificationDetails(
        android: _androidDetails(),
        iOS: const DarwinNotificationDetails(),
      ),
    );
  }

  /// Uses the exact same notification details as schedules/fallback.
  /// If this still doesn't appear while app is open, the issue is OS-level
  /// notification blocking (channel disabled, DND, app notifications disabled, etc).
  Future<void> showDebugHeadsUp() async {
    await showNow(
      id: DateTime.now().millisecondsSinceEpoch.remainder(1 << 31),
      title: 'Debug Heads-Up',
      body: 'Jika ini tidak muncul, maka notifikasi diblok sistem (bukan masalah schedule).',
    );
  }

  // OPTIONAL: kalau mau oneTime "biasa", pakai inexact saja biar aman di semua device
  Future<void> scheduleOneTime({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);
    debugPrint(
        '[Notif] scheduleOneTime id=$id at=$tzDateTime (local=${tz.local.name}) title=$title');

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tzDateTime,
      NotificationDetails(
        android: _androidDetails(),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode:
          AndroidScheduleMode.inexact, // ← aman di semua device
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.wallClockTime,
      matchDateTimeComponents: null,
    );
  }

  // WEEKLY – sekarang ikut cek exact alarm dulu
  Future<void> scheduleWeekly({
    required int id,
    required int weekday, // DateTime.monday..sunday
    required TimeOfDay timeOfDay,
    required String title,
    required String body,
  }) async {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      timeOfDay.hour,
      timeOfDay.minute,
    );

    // geser ke weekday berikutnya yang cocok
    while (scheduled.weekday != weekday || scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    debugPrint(
        '[Notif] scheduleWeekly id=$id weekday=$weekday at=$scheduled (local=${tz.local.name}) title=$title');

    // Track for diagnostics / fallback.
    _scheduledAt[id] = scheduled.toLocal();
    _scheduleForegroundFallback(
      id: id,
      at: scheduled.toLocal(),
      title: title,
      body: body,
    );

    // NOTE:
    // Banyak device (terutama MIUI) cenderung "membunuh" inexact alarm.
    // Untuk pengingat yang "tepat jam", kita coba exactAllowWhileIdle dulu,
    // lalu fallback ke inexact kalau OS menolak.
    debugPrint('[Notif] scheduleWeekly try exactAllowWhileIdle at=$scheduled');

    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        NotificationDetails(
          android: _androidDetails(),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      debugPrint('[Notif] scheduleWeekly scheduled (exactAllowWhileIdle)');
    } catch (e, st) {
      debugPrint('[Notif] scheduleWeekly exact failed -> fallback inexact: $e');
      debugPrint('$st');
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        scheduled,
        NotificationDetails(
          android: _androidDetails(),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      debugPrint('[Notif] scheduleWeekly scheduled (inexact fallback)');
    }
  }

  Future<void> cancel(int id) async {
    _fallbackTimers.remove(id)?.cancel();
    _scheduledAt.remove(id);
    await _plugin.cancel(id);
  }

  Future<void> cancelAll() async {
    for (final t in _fallbackTimers.values) {
      t.cancel();
    }
    _fallbackTimers.clear();
    _scheduledAt.clear();
    await _plugin.cancelAll();
  }

  /// Human-readable debug summary combining "pending" from plugin + in-app fallback state.
  Future<String> getDeliveryDebugSummary() async {
    final pendingSummary = await getPendingSummary();
    final lines = <String>[pendingSummary, '', 'In-app fallback timers:'];
    if (_scheduledAt.isEmpty) {
      lines.add('None');
    } else {
      final entries = _scheduledAt.entries.toList()
        ..sort((a, b) => a.value.compareTo(b.value));
      for (final e in entries.take(20)) {
        final hasTimer = _fallbackTimers.containsKey(e.key);
        lines.add(
            '- id=${e.key} at=${e.value.toLocal().toString()} timer=$hasTimer');
      }
      if (entries.length > 20) {
        lines.add('…and ${entries.length - 20} more');
      }
    }
    return lines.join('\n');
  }

  void _scheduleForegroundFallback({
    required int id,
    required DateTime at,
    required String title,
    required String body,
  }) {
    // Cancel any previous fallback for same id.
    _fallbackTimers.remove(id)?.cancel();
    _scheduledAt[id] = at;

    final now = DateTime.now();
    final diff = at.difference(now);
    if (diff.isNegative) return;

    // Only set fallback when it's soon, otherwise Timer could be killed anyway.
    // This doesn't replace the OS schedule; it's a best-effort helper.
    if (diff > const Duration(minutes: 15)) return;

    _fallbackTimers[id] = Timer(diff, () async {
      try {
        await showNow(id: id, title: title, body: body);
      } finally {
        _fallbackTimers.remove(id)?.cancel();
        _scheduledAt.remove(id);
      }
    });
  }

  /// Debug helper: lists pending notifications that the plugin believes are scheduled.
  /// On Android this is extremely useful to confirm the schedule was persisted.
  Future<List<PendingNotificationRequest>> getPending() async {
    final pending = await _plugin.pendingNotificationRequests();
    debugPrint('[Notif] pending count=${pending.length}');
    for (final p in pending) {
      debugPrint(
          '[Notif] pending id=${p.id} title=${p.title} body=${p.body} payload=${p.payload}');
    }
    return pending;
  }

  /// Debug helper: returns a short printable summary for UI dialogs.
  Future<String> getPendingSummary() async {
    final pending = await _plugin.pendingNotificationRequests();
    if (pending.isEmpty) {
      return 'No pending scheduled notifications (plugin list is empty).';
    }
    final lines = <String>[];
    lines.add('Pending count: ${pending.length}');
    for (final p in pending.take(15)) {
      lines.add('- id=${p.id} title=${p.title ?? ""}');
    }
    if (pending.length > 15) {
      lines.add('…and ${pending.length - 15} more');
    }
    return lines.join('\n');
  }

  Future<void> openAndroidSchedulingSettings() async {
    if (!Platform.isAndroid) return;

    try {
      await const MethodChannel('app.settings')
          .invokeMethod('openExactAlarmSettings');
      return;
    } catch (_) {}

    try {
      await const MethodChannel('app.settings')
          .invokeMethod('openIgnoreBatteryOptimizations');
    } catch (_) {}
  }

  Future<void> openAndroidAppDetails() async {
    if (!Platform.isAndroid) return;
    try {
      await const MethodChannel('app.settings').invokeMethod('openAppDetails');
    } catch (_) {}
  }

  Future<void> openAndroidNotificationSettings() async {
    if (!Platform.isAndroid) return;
    try {
      await const MethodChannel('app.settings')
          .invokeMethod('openAppNotificationSettings');
    } catch (_) {
      // fallback: app details is always available
      await openAndroidAppDetails();
    }
  }

  /// Android 12+ only: ask the user to allow exact alarms for this app.
  /// Many OEMs default this to off; without it, exactAllowWhileIdle will throw
  /// PlatformException(exact_alarms_not_permitted, ...).
  Future<void> requestExactAlarmPermissionIfNeeded() async {
    if (!Platform.isAndroid) return;
    // If the app is already allowed, nothing to do.
    final allowed = await isExactAlarmsAllowed();
    if (allowed) return;
    // Open the system screen where the user can enable it.
    await openAndroidSchedulingSettings();
  }

  Future<bool> isExactAlarmsAllowed() async {
    if (!Platform.isAndroid) return true;
    try {
      final res = await const MethodChannel('app.settings')
          .invokeMethod<bool>('isExactAlarmsAllowed');
      debugPrint('[Notif] isExactAlarmsAllowed=$res');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  Future<bool> isIgnoringBatteryOptimizations() async {
    if (!Platform.isAndroid) return true;
    try {
      final res = await const MethodChannel('app.settings')
          .invokeMethod<bool>('isIgnoringBatteryOptimizations');
      debugPrint('[Notif] isIgnoringBatteryOptimizations=$res');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  // One-time yang "pintar": sudah benar, cukup dipakai seperti sebelumnya
  Future<void> scheduleOneTimeSmart({
    required int id,
    required DateTime dateTime,
    required String title,
    required String body,
  }) async {
    final tz.TZDateTime tzDateTime = tz.TZDateTime.from(dateTime, tz.local);

    // Track for diagnostics / fallback.
    _scheduledAt[id] = dateTime;
    _scheduleForegroundFallback(
      id: id,
      at: dateTime,
      title: title,
      body: body,
    );

    final allowExact = await isExactAlarmsAllowed();
    final ignoreBattery = await isIgnoringBatteryOptimizations();

    debugPrint(
        '[Notif] smartSchedule id=$id at=$tzDateTime exactAllowed=$allowExact ignoreBattery=$ignoreBattery');

    // Sama seperti weekly: coba exact dulu agar "tepat jam", lalu fallback.
    debugPrint('[Notif] smartSchedule try exactAllowWhileIdle');
    try {
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        NotificationDetails(
          android: _androidDetails(),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: null,
      );
      debugPrint('[Notif] smartSchedule scheduled (exactAllowWhileIdle)');
    } catch (e, st) {
      debugPrint('[Notif] smartSchedule exact failed -> fallback inexact: $e');
      debugPrint('$st');
      await _plugin.zonedSchedule(
        id,
        title,
        body,
        tzDateTime,
        NotificationDetails(
          android: _androidDetails(),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.inexact,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: null,
      );
      debugPrint('[Notif] smartSchedule scheduled (inexact fallback)');
    }
  }
}
