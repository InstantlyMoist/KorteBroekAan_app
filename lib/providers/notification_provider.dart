import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:kortebroekaan/providers/shared_preferences_provider.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

class NotificationProvider {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
            requestSoundPermission: true,
            requestBadgePermission: true,
            requestAlertPermission: true,
            onDidReceiveLocalNotification: (
              int id,
              String? title,
              String? body,
              String? payload,
            ) async {

            });

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null);

    initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static void register() {
    unregister();
    flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      translate("_notification.title"),
      translate("_notification.subtitle"),
      _nextMorning(),
      const NotificationDetails(
        iOS: IOSNotificationDetails(
          presentAlert: true,
          presentBadge: false,
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
            'daily notification 0', 'daily notification KorteBroekAan',
            channelDescription: 'daily notification daily_notifications',
            playSound: true),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static void unregister() {
    flutterLocalNotificationsPlugin.cancel(0);
  }

  static TZDateTime _nextMorning() {
    DateTime now = DateTime.now();
    TZDateTime nowTz = TZDateTime.now(local);

    TZDateTime schedule = TZDateTime.utc(now.year, now.month, now.day, SharedPreferencesProvider.notificationTime.hour - 2, SharedPreferencesProvider.notificationTime.minute);
    return schedule;
  }
}
