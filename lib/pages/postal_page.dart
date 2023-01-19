import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'package:freezing_index_flutter/get_current_weather.dart';
import 'package:freezing_index_flutter/models/weather.dart';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/show_weather.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class PostalPage extends StatefulWidget {
  const PostalPage({super.key});

  @override
  _PostalPage createState() => _PostalPage();
}

class _PostalPage extends State<PostalPage> {
  final zipCodeController = TextEditingController();
  final addressController = TextEditingController();

  Weather? _weather;
  Timer? timer;
  String? latitude;
  String? longitude;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('郵便番号から検索', style: TextStyle(fontSize: 18)),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                Navigator.pushNamed(context, '/first');
              }),
        ),
        body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(children: [
              Row(
                children: [
                  Container(
                      child: Text(
                        '郵便番号',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      width: 90),
                  Expanded(
                    child: TextFormField(
                      maxLines: 1,
                      controller: zipCodeController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'ここに入力する',
                        suffixIcon: IconButton(
                          highlightColor: Colors.transparent,
                          icon: Container(
                              width: 36.0, child: new Icon(Icons.clear)),
                          onPressed: () {
                            zipCodeController.clear();
                            addressController.clear();
                          },
                          splashColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                  OutlinedButton(
                      onPressed: () async {
                        var locations =
                            await locationFromAddress(zipCodeController.text);
                        var lat = locations.first.latitude;
                        var long = locations.first.longitude;

                        latitude = "$lat";
                        longitude = "$long";

                        print(locations);
                        postalGetCurrentWeather(latitude, longitude);

                        setState(() {});
                      },
                      child: const Text('検索')),
                ],
              ),
              Container(
                  child: FutureBuilder<dynamic>(
                builder: (context, snapshot) {
                  _weather = snapshot.data;
                  if (snapshot.data == null) {
                    return Container();
                  } else {
                    return weatherBox(_weather!);
                  }
                },
                future: postalGetCurrentWeather(latitude, longitude),
              )),
            ])));
  }

  Widget weatherBox(Weather weather) {
    return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
      Container(
        margin: const EdgeInsets.only(top: 40),
        child: Text(
          '${weather.name}',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              fontFamily: 'Montserrat'),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 25),
        child: Text(
          '現在の水道管凍結指数',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 15),
        child: showLevelIcon(weather),
      ),
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: showLevelText(weather),
      ),
    ]);
  }

  Future postalGetCurrentWeather(String? latitude, String? longitude) async {
    if (latitude == null) {
    } else {
      String apiKey = "985daafdbc6c68ae20ede36ee513bc9a"; // ここにAPIキーを入力する

      // var locations = await locationFromAddress(zipCodeController.text);

      // var lat = locations.first.latitude;
      // var long = locations.first.longitude;

      // latitude = "$lat";
      // longitude = "$long";

      // print(locations);

      //APIキーと現在地の緯度・経度からOpenWeatherMapから天気情報を取得
      var url =
          "https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&APPID=$apiKey&units=metric";
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
      } else {
        throw Exception(response.body);
      }
      return Weather.fromJson(jsonDecode(response.body));
    }
  }
}
