import 'package:flutter/material.dart';
import 'models/weather.dart';

//OpenWeatherから取得したweatherIDから、天気アイコンを表示
showWeatherIcon(Weather weather) {
  switch (weather.id) {
    case 'Clouds':
      return Image.network(
        'http://openweathermap.org/img/w/04d.png',
        scale: 0.4,
      );
    case 'Snow':
      return Image.network(
        'http://openweathermap.org/img/w/13d.png',
        scale: 0.4,
      );
    case 'Rain':
      return Image.network(
        'http://openweathermap.org/img/w/09d.png',
        scale: 0.4,
      );
    case 'Clear':
      return Image.network(
        'http://openweathermap.org/img/w/01d.png',
        scale: 0.4,
      );
    case 'Fog':
      return Image.network(
        'http://openweathermap.org/img/w/50d.png',
        scale: 0.4,
      );
    case 'Mist':
      return Image.network(
        'http://openweathermap.org/img/w/50n.png',
        scale: 0.4,
      );
    case 'Haze':
      return Image.network(
        'http://openweathermap.org/img/w/50d.png',
        scale: 0.4,
      );
    case 'default':
      return Image.network(
        'http://openweathermap.org/img/w/01n.png',
        scale: 0.4,
      );
  }
}

//OpenWeatherから取得した現在地の気温に応じて、水道管凍結指数アイコンを表示
showLevelIcon(Weather weather) {
  if (weather.low > 0.0) {
    return Image.asset('images/level_1.png', scale: 1.8);
  } else if (weather.low > -3.0) {
    return Image.asset('images/level_2.png', scale: 2.3);
  } else if (weather.low > -5.0) {
    return Image.asset('images/level_3.png', scale: 2.3);
  } else if (weather.low > -7.0) {
    return Image.asset('images/level_4.png', scale: 2.3);
  } else if (weather.low > -8.0) {
    return Image.asset('images/level_5.png', scale: 2.3);
  }
}

//OpenWeatherから取得した現在地の気温に応じて、水道管凍結指数(Text)を表示
showLevelText(Weather weather) {
  if (weather.low > 0.0) {
    return const Text(
      '現在、水道管凍結の心配はありません',
      style: TextStyle(fontSize: 15),
    );
  } else if (weather.low > -3.0) {
    return const Text(
      '現在、水道管凍結の可能性があります',
      style: TextStyle(fontSize: 15),
    );
  } else if (weather.low > -5.0) {
    return const Text(
      '現在、水道管凍結に注意です',
      style: TextStyle(fontSize: 15),
    );
  } else if (weather.low > -7.0) {
    return const Text(
      '現在、水道管凍結に警戒です',
      style: TextStyle(fontSize: 15),
    );
  } else if (weather.low > -8.0) {
    return const Text(
      '現在、水道管の破裂に注意です',
      style: TextStyle(fontSize: 15),
    );
  }
}
