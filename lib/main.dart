import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_coding_test_skeleton/pages/freezing_index_page.dart';
import 'package:flutter_coding_test_skeleton/pages/home_page.dart';
import 'package:flutter_coding_test_skeleton/pages/introduction_page.dart';
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
      home: const Tutorial(),
    );
  }
}
