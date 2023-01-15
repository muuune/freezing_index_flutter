import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/models/weather.dart';
import 'package:freezing_index_flutter/show_weather.dart';
import '../get_current_weather.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

class FreezingIndexPage extends StatefulWidget {
  const FreezingIndexPage({super.key});
  @override
  State<FreezingIndexPage> createState() => _FreezingIndexPage();
}

class _FreezingIndexPage extends State<FreezingIndexPage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _init();
    _requestPermissions();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("dispose");
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Weather? _weather;
  String NotificationLevelText = '位置情報をONにすると表示されます';
  String NowLevelText = '位置情報をONにすると表示されます';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        _weather = snapshot.data;
        if (snapshot.data == null) {
          return const Text.rich(
            textAlign: TextAlign.center,
            TextSpan(children: [
              TextSpan(
                text: "天気情報取得中...\n\n",
                style: TextStyle(fontSize: 16),
              ),
              TextSpan(
                  text: "しばらく経っても表示されない場合は\n", style: TextStyle(fontSize: 12)),
              TextSpan(
                  text: "「設定アプリ」から位置情報をオンにしてください",
                  style: TextStyle(fontSize: 12)),
            ]),
          );
        } else {
          return weatherBox(_weather!);
        }
      },
      future: getCurrentWeather(),
    )));
  }

  Widget weatherBox(Weather weather) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10.0),
        child: const Text(
          '現在地の水道管凍結指数',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: showLevelIcon(weather),
      ),
      Container(
        margin: const EdgeInsets.only(top: 10),
        child: showLevelText(weather),
      ),
      Container(
          margin: const EdgeInsets.only(top: 30),
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.notification_add),
              label: const Text('毎日22時に確認通知を送る',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('毎日22時に確認通知を送信しますか？'),
                        content: const Text(
                            '\n水抜き忘れの防止になるので設定をおすすめします。\nシーズンが終了したら通知されなくなります。'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('キャンセル'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              final tz.TZDateTime now =
                                  tz.TZDateTime.now(tz.local);
                              _registerMessage(
                                hour: 16,
                                //minutes: now.minute,
                                message: 'アプリを開いて今日の水道管凍結指数を確認しましょう🚰',
                              );
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              })),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: FloatingActionButton.extended(
            icon: const Icon(Icons.notifications_off),
            label: const Text('       通知をオフにする       ',
                style: TextStyle(fontWeight: FontWeight.bold)),
            onPressed: () async {
              showCupertinoDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return CupertinoAlertDialog(
                      title: const Text('通知をオフにしても良いですか?'),
                      content: const Text('\nオフにした場合、毎日22時に通知が届かなくなります。'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('キャンセル'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _cancelNotification();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  });
            }),
      ),
      Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.help),
              label: const Text('     通知が届かない場合     ',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        content: const Text(
                            '通知が届かない場合は\n「設定アプリ」からアプリの通知をオンにしてください。\n\nそれでも届かない場合は\nスマートフォンの時計表示が、24時間表記でないため通知が届いていない可能性があります。'),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('OK'),
                          ),
                        ],
                      );
                    });
              })),
    ]);
  }

  //ローカル通知設定
  Future<void> _init() async {
    await _configureLocalTimeZone();
    await _initializeNotification();
  }

  //現在のタイムゾーンを設定
  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  Future<void> _initializeNotification() async {
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    //Androidの通知アイコンの設定
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_notification');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  //通知のキャンセル
  Future<void> _cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  //iOSの通知許可リクエストを送る
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

  //通知を開始する 毎日22時に通知がいくよう設定
  Future<void> _registerMessage({
    required int hour,
    //required int minutes,
    required message,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      //minutes,
    );

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0,
      '22時になりました',
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
          icon: '@mipmap/ic_notification',
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
  }

// アプリが再開された時に、天気情報を再取得する
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("state = $state");
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.resumed:
        setState(() {});
        break;
      case AppLifecycleState.detached:
    }
  }
}

  //今夜の水道管凍結指数を計算している。21時現在の気温のため通常より-2°下げた計算になっている。例)-1°の場合-3°とみなす
  //notificationText(Weather weather) {
  //if (weather.low > 1.0) {
      //return NotificationLevelText = '今夜は水道管凍結の心配はありません';
    //} else if (weather.low > -1.0) {
      //return NotificationLevelText = '今夜は水道管凍結の可能性があります';
    //} else if (weather.low > -3.0) {
      //return NotificationLevelText = '今夜は水道管凍結に注意です';
    //} else if (weather.low > -5.0) {
      //return NotificationLevelText = '今夜は水道管凍結に警戒です';
    //} else {
      //return NotificationLevelText = '今夜は水道管の破裂に注意です';
    //}
