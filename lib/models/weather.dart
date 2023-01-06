class Weather {
  final double temp;
  final double feelsLike;
  final double low;
  final double high;
  final String description;
  final String id;
  final double pressure;
  final double humidity;
  final String name;

  Weather({
    required this.temp,
    required this.feelsLike,
    required this.low,
    required this.high,
    required this.description,
    required this.id,
    required this.pressure,
    required this.humidity,
    required this.name,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      id: json['weather'][0]['main'],
      pressure: json['main']['pressure'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      name: json['name'],
    );
  }
}
