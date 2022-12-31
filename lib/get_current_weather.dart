import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'models/weather.dart';

String? latitude;
String? longitude;

// 現在地の緯度・経度を取得し、OpenWeatherから天気情報を取得する
Future getCurrentWeather() async {
  String apiKey = "ここにAPIキー";
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
