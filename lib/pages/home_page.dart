import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/get_current_weather.dart';
import 'package:flutter_coding_test_skeleton/pages/current_weather_page.dart';
import 'package:flutter_coding_test_skeleton/pages/freezing_index_page.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import '../models/weather.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    mainLoop();
  }

  // 選択中フッターメニューのインデックスを一時保存する用変数
  int selectedIndex = 0;
  String LevelText = '位置情報をONにすると表示されます';
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // 切り替える画面のリスト
  List<Widget> display = [FreezingIndexPage(), CurrentWeatherPage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: display[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.ac_unit), label: '水道管凍結指数'),
            BottomNavigationBarItem(
                icon: Icon(Icons.my_location), label: '天気情報'),
          ],
          // 現在選択されているフッターメニューのインデックス
          currentIndex: selectedIndex,
          // フッター領域の影
          elevation: 0,
          // フッターメニュータップ時の処理
          onTap: (int index) {
            selectedIndex = index;
            setState(() {});
          },
          // 選択中フッターメニューの色
          fixedColor: Colors.blue,
        ));
  }

  Future<void> mainLoop() async {
    while (true) {
      await Future<void>.delayed(const Duration(minutes: 1));
      setState(() {
        getCurrentWeather();
        print('1分経ちました');
      });
    }
  }
}
