import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:freezing_index_flutter/pages/postal_page.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('設定', style: TextStyle(fontSize: 18)),
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: ListView(children: [
          _menuItem1("郵便番号から検索", const Icon(Icons.push_pin), context),
          _menuItem2("天気情報が表示されない場合", const Icon(Icons.help), context),
          _menuItem3("通知が来ない場合", const Icon(Icons.help), context),
          _menuItem4("プライバシーポリシー", const Icon(Icons.policy), context),
        ]),
      ),
    );
  }

  //郵便番号から検索
  Widget _menuItem1(String title, Icon icon, context) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const PostalPage(),
              fullscreenDialog: true,
            ),
          );
        },
      ),
    );
  }

  //天気情報が表示されない場合
  Widget _menuItem2(String title, Icon icon, context) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        onTap: () {
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  content: const Text(
                      '天気情報が表示されない場合は\n「設定アプリ」からアプリの位置情報をオンにしてください。\n\n※20秒経っても表示されない場合は\n「郵便番号から検索」に自動で遷移しています。'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Widget _menuItem3(String title, Icon icon, context) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        onTap: () {
          showCupertinoDialog(
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  content: const Text(
                      '通知が届かない場合は\n「設定アプリ」からアプリの通知をオンにしてください。\n\nそれでも届かない場合は\nスマートフォンの時計表示が、24時間表記でないため通知が届いていない可能性があります。'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('OK'),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }

  Widget _menuItem4(String title, Icon icon, context) {
    return Container(
      decoration: new BoxDecoration(
          border:
              new Border(bottom: BorderSide(width: 1.0, color: Colors.grey))),
      child: ListTile(
        leading: icon,
        title: Text(
          title,
          style: const TextStyle(color: Colors.black, fontSize: 16.0),
        ),
        onTap: () {
          _opnenUrl();
        },
      ),
    );
  }

  void _opnenUrl() async {
    const url =
        'https://adorable-volcano-5e9.notion.site/b22a7aafe9cd4470a1c0d275e0b8f20a'; //←ここに表示させたいURLを入力する
    if (await canLaunch(url)) {
      await launch(
        url,
        //iOS(アプリ内に表示か外に表示か)
        forceSafariVC: true,
        //Android(アプリ内に表示か外に表示か→trueだと上手くいかない)
        forceWebView: false,
      );
    } else {
      throw 'このURLにはアクセスできません';
    }
  }
}
