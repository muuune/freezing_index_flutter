import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/main.dart';
import 'package:flutter_coding_test_skeleton/models/weather.dart';
import 'package:flutter_coding_test_skeleton/show_weather.dart';
import 'get_current_weather.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class FreezingIndexPage extends StatefulWidget {
  const FreezingIndexPage({super.key});

  @override
  State<FreezingIndexPage> createState() => _FreezingIndexPage();
}

class _FreezingIndexPage extends State<FreezingIndexPage> {
  Weather? _weather;
  String LevelText = '位置情報をONにすると表示されます';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    mainLoop();
    _init();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        _weather = snapshot.data;
        if (snapshot.data == null) {
          return const Text("天気情報読み込み中...");
        } else {
          return weatherBox(_weather!);
        }
      },
      future: getCurrentWeather(),
    )));
  }

  Widget weatherBox(Weather weather) {
    notificationText(weather);
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10.0),
        child: const Text(
          '現在地の水道凍結指数',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: showLevelIcon(weather),
      ),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: showLevelText(weather),
      ),
      Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        FloatingActionButton(
            child: Icon(Icons.notification_add),
            onPressed: () async {
              final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
              await _registerMessage(
                hour: now.hour,
                minutes: now.minute + 1,
                message: LevelText,
              );
            }),
        const SizedBox(
          width: 10,
        ),
        FloatingActionButton(
            child: Icon(Icons.notifications_off),
            onPressed: () async {
              await _cancelNotification();
            }),
      ]),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: showWeatherIcon(),
      ),
      Container(
          margin: const EdgeInsets.all(10.0),
          child: Text(
            "${weather.temp}°C",
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          )),
      Container(
          margin: const EdgeInsets.all(5.0), child: Text(weather.description)),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("体感温度: ${weather.feelsLike}°C")),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("最高気温: ${weather.high}°C 最低気温: ${weather.low}°C")),
    ]);
  }

  // 1分ごとに定期実行
  Future<void> mainLoop() async {
    while (true) {
      await Future<void>.delayed(const Duration(minutes: 1));
      setState(() {
        getCurrentWeather();
        weatherBox;
        print('1分経ちました');
      });
    }
  }

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
  Future<void> _init() async {
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

    const InitializationSettings initializationSettings =
        InitializationSettings(
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

  Future<void> _registerMessage({
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
          .then(
              (_) => flnp.show(0, 'トウケツライフ', LevelText, NotificationDetails()));
    }
  }
}
