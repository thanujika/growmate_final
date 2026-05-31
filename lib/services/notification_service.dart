import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/reminder.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        debugPrint('Notification tapped: ${response.payload}');
      },
    );

    // Request notification permission on Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  Future<void> scheduleReminderNotification(Reminder reminder) async {
    // Use hashCode to safely convert string id to int
    final id = reminder.id.hashCode.abs();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      channelDescription: 'Notifications for crop reminders',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
      enableVibration: true,
      playSound: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final scheduledTime = _scheduleTime(reminder.dateTime);

    // Schedule notification
    await _notificationsPlugin.zonedSchedule(
      id,
      '🌱 ${reminder.reminderTypeString}',
      'Time to ${reminder.reminderTypeString.toLowerCase()} for ${reminder.fieldName}',
      scheduledTime,
      notificationDetails,
      payload: reminder.id,
      // Fixed: replaced deprecated androidAllowWhileIdle
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );

    debugPrint(
        'Notification scheduled for reminder ${reminder.id} at $scheduledTime');
  }

  /// Schedules 5 minutes before the reminder time.
  /// Falls back to 5 seconds from now if the calculated time is in the past.
  tz.TZDateTime _scheduleTime(DateTime dateTime) {
    final scheduledDate = tz.TZDateTime.from(dateTime, tz.local)
        .subtract(const Duration(minutes: 5));
    final now = tz.TZDateTime.now(tz.local);

    if (scheduledDate.isBefore(now)) {
      debugPrint('Warning: Scheduled time is in the past, using fallback.');
      return now.add(const Duration(seconds: 5));
    }

    return scheduledDate;
  }

  Future<void> cancelNotification(String reminderId) async {
    final id = reminderId.hashCode.abs();
    await _notificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await _notificationsPlugin.cancelAll();
  }

  Future<void> showTestNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'reminder_channel',
      'Reminder Notifications',
      channelDescription: 'Notifications for crop reminders',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      999,
      'GrowMate Test',
      'Notifications are working!',
      notificationDetails,
    );
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notificationsPlugin.pendingNotificationRequests();
  }
}
