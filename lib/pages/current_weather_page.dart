import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/get_current_weather.dart';
import 'package:flutter_coding_test_skeleton/pages/freezing_index_page.dart';
import 'package:flutter_coding_test_skeleton/show_weather.dart';
import '../models/weather.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPage();
}

class _CurrentWeatherPage extends State<CurrentWeatherPage> {
  Weather? _weather;

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
    ]);
  }
}
