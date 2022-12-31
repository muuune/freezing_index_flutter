import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/main.dart';
import 'package:flutter_coding_test_skeleton/models/weather.dart';
import 'package:flutter_coding_test_skeleton/show_weather.dart';
import 'get_current_weather.dart';
import 'notification_weather.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:async';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  Weather? _weather;

  @override
  void initState() {
    super.initState();
    mainLoop();
    init();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
            await registerMessage(
              hour: 15,
              minutes: 01,
              message: LevelText,
            );
          },
          child: const Icon(Icons.autorenew),
        ),
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
}
