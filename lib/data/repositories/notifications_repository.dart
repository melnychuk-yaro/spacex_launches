import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsRepository {
  late final String currentTimeZone;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: const AndroidInitializationSettings('app_icon'),
    iOS: const IOSInitializationSettings(),
    macOS: const MacOSInitializationSettings(),
  );

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
    required String title,
    required String body,
    required DateTime launchTimeUTC,
  }) async {
    final notificationTime = await _getNotiticationTime(launchTimeUTC);
    print(notificationTime);
    print(notificationTime.runtimeType);
    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      title,
      body,
      notificationTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<tz.TZDateTime> _getNotiticationTime(DateTime launchTimeUtc) async {
    final time = launchTimeUtc.subtract(const Duration(minutes: 5));
    currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
    print(time);
    final currentLocation = tz.getLocation(currentTimeZone);
    return tz.TZDateTime.from(time, currentLocation);
  }
}
