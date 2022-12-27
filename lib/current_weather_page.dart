import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_coding_test_skeleton/models/weather.dart';
import 'package:geolocator/geolocator.dart';

class CurrentWeatherPage extends StatefulWidget {
  const CurrentWeatherPage({super.key});

  @override
  State<CurrentWeatherPage> createState() => _CurrentWeatherPageState();
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  Weather? _weather;
  final String _city = "現在地の水道凍結指数";
  String? latitude;
  String? longitude;

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("トウケツライフ"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            getCurrentWeather();
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
        child: Text(_city),
      ),
      Container(
        margin: const EdgeInsets.all(10.0),
        child: showIcon(),
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
          child: Text("Feels:${weather.feelsLike}°C")),
      Container(
          margin: const EdgeInsets.all(5.0),
          child: Text("H:${weather.high}°C L:${weather.low}°C")),
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
        "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric";
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
    } else {
      throw Exception(response.body);
    }
    return Weather.fromJson(jsonDecode(response.body));
  }

  dynamic showIcon() {
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
}
