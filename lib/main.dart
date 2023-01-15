import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/pages/first_page.dart';
import 'package:freezing_index_flutter/pages/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {'/first': (context) => const HomePage()},
      title: 'トウケツライフ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // チュートリアル画面に移動
      home: const FirstPage(),
    );
  }
}
