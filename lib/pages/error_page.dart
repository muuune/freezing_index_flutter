import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            centerTitle: true,
            title: const Text('トウケツライフ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            automaticallyImplyLeading: false,
          )),
      body: Center(
          child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _TextButton(context),
        ],
      )),
    );
  }

  Widget _TextButton(context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
            margin: const EdgeInsets.all(20.0),
            child: Image.asset('images/404_girl.png', scale: 5)),
        Container(
            child: TextButton(
          onPressed: () {
            Navigator.pushNamed(context, '/first');
          },
          child: const Text(
            'ホームに戻る',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        )),
      ],
    );
  }
}
