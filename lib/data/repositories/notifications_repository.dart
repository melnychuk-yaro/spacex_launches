import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../../logic/services/failure.dart';

class NotificationsRepository {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('app_icon'),
    iOS: const IOSInitializationSettings(),
    macOS: const MacOSInitializationSettings(),
  );
  static const Duration notificationDelay = Duration(minutes: 5);

  Future<void> init() async {
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        if (payload != null) print('notification payload: $payload');
      },
    );
    tz.initializeTimeZones();
  }

  static const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.max,
    priority: Priority.high,
    showWhen: false,
  );

  static const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  Future<void> scheduleNotification({
    required String id,
    required String title,
    required String body,
    required DateTime launchTimeUTC,
  }) async {
    final notificationTime = await _getNotiticationTime(launchTimeUTC);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _generateIntId(id),
      title,
      body,
      notificationTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: id,
    );
  }

  Future<void> cancelNotification(String id) async {
    await flutterLocalNotificationsPlugin.cancel(
      _generateIntId(id),
    );
  }

  Future<Set<String>> getPendingNotifications() async {
    final notifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return notifications.map((item) => item.payload ?? '').toSet();
  }

  Future<tz.TZDateTime> _getNotiticationTime(DateTime launchTimeUtc) async {
    final time = launchTimeUtc.subtract(notificationDelay);
    if (DateTime.now().isAfter(time)) {
      throw Failure('The lauhch is live');
    }
    final currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    final currentLocation = tz.getLocation(currentTimeZone);
    return tz.TZDateTime.from(time, currentLocation);
  }

  int _generateIntId(String id) {
    return id.codeUnits.reduce((value, element) => value + element);
  }
}
