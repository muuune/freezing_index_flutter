# 【Flutter】 トウケツライフ

寒冷地では、寒さによって水道管が凍ってしまうことから、毎晩の水抜きは当たり前のように行われています。

しかし、寒冷地に引っ越してきた大学生にとって「水抜き」とは全く未知のこと。

既存の天気アプリでは、水道管凍結指数が表示されているアプリもあるが、極めて表示が小さく、そもそも毎晩凍結指数をお知らせしてくれるアプリは存在しない。

そこで、現在地の天気情報から水道管凍結指数を計算し、毎晩21時に通知をしてくれるアプリケーションを開発した。

# デモ動画

"hoge"の魅力が直感的に伝えわるデモ動画や図解を載せる

# アプリの概要

Geolocatorで、現在地の緯度・経度を取得。

その後、そのデータを用いてOpenWeatherMapから天気情報を取得。

取得した天気情報から、水道管凍結指数を計算し、アプリ上で表示。

毎日21時に凍結指数を通知することができ、今夜の水抜きが必要かどうか確認することができる。

水抜きの防止にもつながります。

# Requirement

"hoge"を動かすのに必要なライブラリなどを列挙する

* huga 3.5.2
* hogehuga 1.0.2

# Installation

Requirementで列挙したライブラリなどのインストール方法を説明する

```bash
pip install huga_package
```

# Usage

DEMOの実行方法など、"hoge"の基本的な使い方を説明する

```bash
git clone https://github.com/hoge/~
cd examples
python demo.py
```

# Note

注意点などがあれば書く

# Author

作成情報を列挙する

* 作成者
* 所属
* E-mail

# License
ライセンスを明示する

"hoge" is under [MIT license](https://en.wikipedia.org/wiki/MIT_License).

社内向けなら社外秘であることを明示してる

"hoge" is Confidential.