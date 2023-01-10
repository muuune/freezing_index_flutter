
# トウケツライフ(Frozen Life)

寒冷地では、寒さによって水道管が凍ってしまうことから、毎晩の水抜きは当たり前のように行われています🚰

しかし、寒冷地に引っ越してきた大学生にとって「水抜き」とは全く未知のこと。

既存の天気アプリでは、水道管凍結指数が表示されているアプリもあるが、極めて表示が小さく、そもそも毎晩凍結指数をお知らせしてくれるアプリは存在しない。

そこで、現在地の天気情報から水道管凍結指数を計算し、毎晩21時に通知をしてくれるアプリケーションを開発した。

# ダウンロードはこちら
* AppleStore: 現在審査中...
* GooglePlayStore: 現在審査中...

# デモ動画

![ezgif-4-128466680a](https://user-images.githubusercontent.com/74311952/211473419-b025e790-b6ef-4799-a3ef-f08524b83d66.gif)

![ezgif-4-5239fa1fc5](https://user-images.githubusercontent.com/74311952/211474547-d7569275-aa13-41b3-8759-782b5105a08b.gif)


# アプリの概要

Geolocatorで、現在地の緯度・経度を取得。

その後、そのデータを用いてOpenWeatherMapから天気情報を取得。

取得した天気情報から、水道管凍結指数を計算し、アプリ上で表示。

毎日21時に凍結指数を通知することができ、今夜の水抜きが必要かどうか確認することができる。

水抜きの防止にもつながります。

# 開発する上で使用したAPI・パッケージ

* OpenWeatherMap API (https://openweathermap.org/)
* geolocator : ^9.0.2
* flutter_local_notifications: ^13.0.0
* timezone: ^0.9.1
* flutter_native_timezone: ^2.0.0
* shared_preferences: ^2.0.15
* tutorial_coach_mark: ^1.2.4
* http: ^0.13.5
* flutter_riverpod: ^2.1.3
* dio: ^4.0.6
* flutter_launcher_icons: ^0.11.0
* flutter_native_splash: ^2.2.16

# 開発する上で苦労した点

* アプリライフサイクルを理解し、inactive/paused/resumed/detached時においても天気情報や指数の計算を常時処理できるよう、実装したこと。
* 毎晩、今夜の水道管凍結指数の通知が届くように実装した点。

# 最後に

寒冷地で新生活を送る大学生をターゲットに、アプリの開発を行いました。

アプリのデザインや機能面は随時改善していきます🚰

是非ダウンロードして使ってみてください！