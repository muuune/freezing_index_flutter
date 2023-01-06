import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/pages/home_page.dart';
import 'package:freezing_index_flutter/pages/introduction_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _showTutorial(context));
    return Scaffold();
  }

  void _showTutorial(BuildContext context) async {
    final pref = await SharedPreferences.getInstance();

    if (pref.getBool('isAlreadyFirstLaunch') != true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Tutorial(),
          fullscreenDialog: true,
        ),
      );
      pref.setBool('isAlreadyFirstLaunch', true);
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}
