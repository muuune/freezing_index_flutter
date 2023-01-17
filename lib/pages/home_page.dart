import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/pages/current_weather_page.dart';
import 'package:freezing_index_flutter/pages/freezing_index_page.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:freezing_index_flutter/pages/postal_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  //選択中フッターメニューのインデックスを一時保存する用変数
  int selectedIndex = 0;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  //切り替える画面のリスト
  List<Widget> display = [
    const FreezingIndexPage(),
    const CurrentWeatherPage(),
  ];

  //フッターメニュー
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: AppBar(
              centerTitle: true,
              title: const Text('トウケツライフ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              leading: IconButton(
                  icon: const Icon(Icons.help),
                  onPressed: () {
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
                  }),
              actions: [
                IconButton(
                  icon: const Icon(Icons.push_pin),
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PostalPage(),
                        fullscreenDialog: true,
                      ),
                    )
                  },
                ),
              ],
              automaticallyImplyLeading: false,
            )),
        body: display[selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          items: const [
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
          fixedColor: Colors.blue,
        ));
  }
}
