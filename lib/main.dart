import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/pages/first_page.dart';
import 'package:freezing_index_flutter/pages/freezing_index_page.dart';
import 'package:freezing_index_flutter/pages/home_page.dart';
import 'package:freezing_index_flutter/pages/introduction_page.dart';
import 'package:introduction_screen/introduction_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/first': (context) => HomePage()},
      title: 'トウケツライフ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // チュートリアル画面に移動
      home: const FirstPage(),
    );
  }
}
