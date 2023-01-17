import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/get_current_weather.dart';
import 'package:freezing_index_flutter/pages/postal_page.dart';
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
  Timer? timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print("dispose");
    WidgetsBinding.instance.removeObserver(this);
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
          timer = Timer(const Duration(seconds: 20), () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PostalPage()),
            );
          });
          return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _getLoadingIndicator(),
                    _getHeading(),
                    _getHeading2(),
                  ]));
        } else {
          timer!.cancel();
          return weatherBox(_weather!);
        }
      },
      future: getCurrentWeather(),
    )));
  }

  Widget _getLoadingIndicator() {
    return Padding(
        child: Container(
            child: const CircularProgressIndicator(strokeWidth: 5),
            width: 30,
            height: 30),
        padding: const EdgeInsets.all(20));
  }

  Widget _getHeading() {
    return const Padding(
        child: Text(
          '天気情報取得中...',
          style: TextStyle(color: Colors.white, fontSize: 15),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.all(10));
  }

  Widget _getHeading2() {
    return const Padding(
        child: Text(
          'しばらく経っても表示されない場合は\n設定から位置情報をオンにしてください',
          style: TextStyle(color: Colors.white, fontSize: 10),
          textAlign: TextAlign.center,
        ),
        padding: EdgeInsets.all(10));
  }

  Widget weatherBox(Weather weather) {
    return Scaffold(
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(right: 10, top: 30, bottom: 5),
            child: FloatingActionButton(
              onPressed: () {
                setState(() {});
              },
              tooltip: 'Increment',
              child: Icon(Icons.refresh, size: 30),
            )),
        body: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.location_on),
                  Text(' 現在の天気情報',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 21,
                      ))
                ]),
          ),
          Container(
            child: showWeatherIcon(weather),
          ),
          Container(
              child: Text(weather.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 25))),
          Container(
              margin: const EdgeInsets.all(3.0),
              child: Text(
                "${weather.temp}°",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 70,
                    fontFamily: 'Montserrat'),
              )),
          Container(
              margin: const EdgeInsets.all(3.0),
              child: Text(weather.description,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17))),
          Container(
              margin: const EdgeInsets.all(3.0),
              child: Text("体感温度: ${weather.feelsLike}°",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17))),
          Container(
              margin: const EdgeInsets.all(3.0),
              child: Text("気圧: ${weather.pressure}hPa",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17))),
          Container(
              margin: const EdgeInsets.all(3.0),
              child: Text("湿度: ${weather.humidity}%",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17))),

          // Container(
          //     margin: const EdgeInsets.only(top: 30),
          //     child: FloatingActionButton.extended(
          //         icon: const Icon(Icons.help),
          //         label: const Text('天気情報について',
          //             style: TextStyle(fontWeight: FontWeight.bold)),
          //         onPressed: () async {
          //           showCupertinoDialog(
          //               context: context,
          //               builder: (BuildContext context) {
          //                 return CupertinoAlertDialog(
          //                   content: const Text(
          //                       '天気情報はOpenWeatherMapから取得しています。\n正確な天気情報ではないので、参考までにお願いします。'),
          //                   actions: <Widget>[
          //                     TextButton(
          //                       onPressed: () {
          //                         Navigator.pop(context);
          //                       },
          //                       child: const Text('OK'),
          //                     ),
          //                   ],
          //                 );
          //               });
          //         })),
        ])));
  }
}

  // アプリが再開された時に、天気情報を再取得する
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) async {
//     print("state = $state");
//     switch (state) {
//       case AppLifecycleState.inactive:
//       case AppLifecycleState.paused:
//       case AppLifecycleState.resumed:
//         setState(() {});
//         break;
//       case AppLifecycleState.detached:
//     }
//   }
// }

  //アプリが再開された時に、天気情報を再取得する
  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) async {
  //   print("state = $state");
  //   switch (state) {
  //     case AppLifecycleState.inactive:
  //     case AppLifecycleState.paused:
  //     case AppLifecycleState.resumed:
  //       setState(() {});
  //       break;
  //     case AppLifecycleState.detached:
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   final nav = Navigator.of(context);
  //   nav.pushNamed('/first');
  // }
