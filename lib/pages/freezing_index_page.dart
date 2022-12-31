import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/main.dart';
import 'package:flutter_coding_test_skeleton/models/weather.dart';
import 'package:flutter_coding_test_skeleton/show_weather.dart';
import '../get_current_weather.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'current_weather_page.dart';
import 'home_page.dart';

class FreezingIndexPage extends StatefulWidget {
  const FreezingIndexPage({super.key});

  @override
  State<FreezingIndexPage> createState() => _FreezingIndexPage();
}

class _FreezingIndexPage extends State<FreezingIndexPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Weather? _weather;
  String LevelText = '位置情報をONにすると表示されます';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
      Container(
          margin: const EdgeInsets.only(top: 20),
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.notification_add),
              label: const Text('毎日21時に通知する',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
                await _registerMessage(
                  hour: now.hour,
                  minutes: now.minute + 1,
                  message: LevelText,
                );
              })),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: FloatingActionButton.extended(
            icon: const Icon(Icons.notifications_off),
            label: const Text('通知をオフにする',
                style: const TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () async {
              await _cancelNotification();
            }),
      ),
    ]);
  }

  // 1分ごとに定期実行
  Future<void> mainLoop() async {
    while (true) {
      await Future<void>.delayed(const Duration(minutes: 1));
      setState(() {
        getCurrentWeather();
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

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  static const _screens = [
    FreezingIndexPage(),
    CurrentWeatherPage(),
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'お気に入り'),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'お知らせ'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
      ],
      type: BottomNavigationBarType.fixed,
    ));
  }
}
