import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/current_weather_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IB Flutter CodeCheck',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CurrentWeatherPage(),
    );
  }
}
