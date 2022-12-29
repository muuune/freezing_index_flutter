import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/main.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_coding_test_skeleton/models/weather.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  Weather? _weather;
  String? latitude;
  String? longitude;
  String LevelText = '位置情報をONにすると表示されます';

  void main() {
    notify();
    notificationText;
    runApp(MyApp());
  }

  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            notify();
          },
          child: const Icon(Icons.autorenew),
        ),
        body: Center(
          child: FutureBuilder<dynamic>(
            builder: (context, snapshot) {
              _weather = snapshot.data;
              if (snapshot.data == null) {
                return const Text("Error getting weather");
              } else {
                return weatherBox(_weather!);
              }
            },
            future: getCurrentWeather(),
          ),
        ));
  }

  Widget weatherBox(Weather weather) {
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

  Future getCurrentWeather<Integer>() async {
    String apiKey = "985daafdbc6c68ae20ede36ee513bc9a";
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    var lat = position.latitude;
    var long = position.longitude;

    latitude = "$lat";
    longitude = "$long";

    var url =
        "https://api.openweathermap.org/data/2.5/weather?lat=39.802768&lon=141.137075&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
    } else {
      throw Exception(response.body);
    }
    return Weather.fromJson(jsonDecode(response.body));
  }

  dynamic showWeatherIcon() {
    switch (_weather?.id) {
      case 'Clouds':
        return Image.network(
          'http://openweathermap.org/img/w/04d.png',
          scale: 0.5,
        );
      case 'Snow':
        return Image.network(
          'http://openweathermap.org/img/w/13d.png',
          scale: 0.5,
        );
      case 'Rain':
        return Image.network(
          'http://openweathermap.org/img/w/09d.png',
          scale: 0.5,
        );
      case 'Clear':
        return Image.network(
          'http://openweathermap.org/img/w/01d.png',
          scale: 0.5,
        );
      case 'Fog':
        return Image.network(
          'http://openweathermap.org/img/w/50d.png',
          scale: 0.5,
        );
      case 'Mist':
        return Image.network(
          'http://openweathermap.org/img/w/50n.png',
          scale: 0.5,
        );
      case 'Haze':
        return Image.network(
          'http://openweathermap.org/img/w/50d.png',
          scale: 0.5,
        );
      case 'default':
        return Image.network(
          'http://openweathermap.org/img/w/01n.png',
          scale: 0.5,
        );
    }
  }

  showLevelIcon(Weather weather) {
    if (weather.low > 0.0) {
      return Image.asset('images/level1.png', scale: 15);
    } else if (weather.low > -3.0) {
      return Image.asset('images/level2.png', scale: 15);
    } else if (weather.low > -5.0) {
      return Image.asset('images/level3.png', scale: 15);
    } else if (weather.low > -7.0) {
      return Image.asset('images/level4.png', scale: 15);
    } else if (weather.low > -8.0) {
      return Image.asset('images/level5.png', scale: 15);
    }
  }

  showLevelText(Weather weather) {
    if (weather.low > 0.0) {
      return Text('水道管凍結の心配はないです');
    } else if (weather.low > -3.0) {
      return Text('水道管凍結の可能性があります');
    } else if (weather.low > -5.0) {
      return Text('水道管凍結に注意です');
    } else if (weather.low > -7.0) {
      return Text('水道管凍結に警戒です');
    } else if (weather.low > -8.0) {
      return Text('水道管の破裂に注意です');
    }
  }

  notificationText(Weather weather) {
    if (weather.low > 0.0) {
      return LevelText = '水道管凍結の心配はないです';
    } else if (weather.low > -3.0) {
      return LevelText = '水道管凍結の可能性があります';
    } else if (weather.low > -5.0) {
      return LevelText = '水道管凍結に注意です';
    } else if (weather.low > -7.0) {
      return LevelText = '水道管凍結に警戒です';
    } else if (weather.low > -8.0) {
      return LevelText = '水道管の破裂に注意です';
    }
  }

  //通知機能
  Future<void> notify() {
    final flnp = FlutterLocalNotificationsPlugin();
    return flnp
        .initialize(
          InitializationSettings(
            iOS: DarwinInitializationSettings(),
          ),
        )
        .then((_) =>
            flnp.show(0, '現在地の水道管凍結指数', LevelText, NotificationDetails()));
  }
}
