import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/get_current_weather.dart';
import 'package:freezing_index_flutter/pages/freezing_index_page.dart';
import 'package:freezing_index_flutter/show_weather.dart';
import '../models/weather.dart';

class CurrentWeatherPage extends StatefulWidget with WidgetsBindingObserver {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPage();
}

class _CurrentWeatherPage extends State<CurrentWeatherPage>
    with WidgetsBindingObserver {
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    print("dispose");
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: FutureBuilder<dynamic>(
      builder: (context, snapshot) {
        _weather = snapshot.data;
        if (snapshot.data == null) {
          return const CircularProgressIndicator(
            color: Colors.blue,
          );
        } else {
          return weatherBox(_weather!);
        }
      },
      future: getCurrentWeather(),
    )));
  }

  @override
  Widget weatherBox(Weather weather) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        margin: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: const [
          Icon(Icons.location_on),
          Text(' 現在の天気情報',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ))
        ]),
      ),
      Container(
        child: showWeatherIcon(weather),
      ),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text(weather.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 25))),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text(
            "${weather.temp}°",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 60,
                fontFamily: 'Montserrat'),
          )),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text(weather.description,
              style: const TextStyle(fontWeight: FontWeight.bold))),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("体感温度: ${weather.feelsLike}°",
              style: const TextStyle(fontWeight: FontWeight.bold))),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("気圧: ${weather.pressure}hPa",
              style: const TextStyle(fontWeight: FontWeight.bold))),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("湿度: ${weather.humidity}%",
              style: const TextStyle(fontWeight: FontWeight.bold))),
      Container(
          margin: const EdgeInsets.only(top: 40),
          child: FloatingActionButton.extended(
              icon: const Icon(Icons.help),
              label: const Text('天気情報が表示されない場合',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        content: const Text(
                            '天気情報が表示されない場合は\n「設定」からアプリの位置情報をオンにしてください。'),
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

// 各ステータスにおけるバックグラウンド実行(1分おき)
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    print("stete = $state");
    switch (state) {
      case AppLifecycleState.inactive:
        print('非アクティブになったときの処理');
        while (true) {
          await Future<void>.delayed(const Duration(minutes: 1));
          if (mounted) {
            setState(() {
              getCurrentWeather;
              print('1分経ったので、再取得します(非アクティブ状態)');
            });
          }
        }
      case AppLifecycleState.paused:
        print('停止されたときの処理');
        while (true) {
          await Future<void>.delayed(const Duration(minutes: 1));
          if (mounted) {
            setState(() {
              getCurrentWeather;
              print('1分経ったので、再取得します(停止状態)');
            });
          }
        }
      case AppLifecycleState.resumed:
        print('再開されたときの処理');
        while (true) {
          await Future<void>.delayed(const Duration(minutes: 1));
          if (mounted) {
            setState(() {
              getCurrentWeather;
              print('1分経ったので、再取得します(再開状態)');
            });
          }
        }
      case AppLifecycleState.detached:
        print('破棄されたときの処理');
        while (true) {
          await Future<void>.delayed(const Duration(minutes: 1));
          if (mounted) {
            setState(() {
              getCurrentWeather;
              print('1分経ったので、再取得します(破棄状態)');
            });
          }
        }
    }
  }
}
