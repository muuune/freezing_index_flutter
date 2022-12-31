import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'models/weather.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

String LevelText = '位置情報をONにすると表示されます';
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

// 最低気温に応じて、通知する内容を変更する
notificationText(Weather weather) {
  if (weather.low > 0.0) {
    return LevelText = '今夜は水道管凍結の心配はないです';
  } else if (weather.low > -3.0) {
    return LevelText = '今夜は水道管凍結の可能性があります';
  } else if (weather.low > -5.0) {
    return LevelText = '今夜は水道管凍結に注意です';
  } else if (weather.low > -7.0) {
    return LevelText = '今夜は水道管凍結に警戒です';
  } else if (weather.low > -8.0) {
    return LevelText = '今夜は水道管の破裂に注意です';
  }
}

// 毎日21時に定期通知する
Future<void> init() async {
  await _configureLocalTimeZone();
  await _initializeNotification();
}

Future<void> _configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

Future<void> _initializeNotification() async {
  const DarwinInitializationSettings initializationSettingsIOS =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
  );
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('ic_notification');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

Future<void> _cancelNotification() async {
  await flutterLocalNotificationsPlugin.cancelAll();
}

Future<void> _requestPermissions() async {
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
}

Future<void> registerMessage({
  required int hour,
  required int minutes,
  required message,
}) async {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(
    tz.local,
    now.year,
    now.month,
    now.day,
    hour,
    minutes,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    'トウケツライフ',
    message,
    scheduledDate,
    NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        importance: Importance.max,
        priority: Priority.high,
        ongoing: true,
        styleInformation: BigTextStyleInformation(message),
        icon: 'ic_notification',
      ),
      iOS: const DarwinNotificationDetails(
        badgeNumber: 1,
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );

  // 使用していない通知機能
  Future<void> notify() {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp
        .initialize(
          InitializationSettings(
            iOS: DarwinInitializationSettings(),
          ),
        )
        .then((_) => flnp.show(0, 'トウケツライフ', LevelText, NotificationDetails()));
  }
}
