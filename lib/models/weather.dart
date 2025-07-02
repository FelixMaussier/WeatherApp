class Weather {
  final String city;
  final double temperature;
  final double windSpeed;
  final int humidity;
  final String description;
  final String iconUrl;

  Weather({
    required this.city,
    required this.temperature,
    required this.windSpeed,
    required this.humidity,
    required this.description,
    required this.iconUrl,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['location']['name'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      windSpeed: (json['current']['wind_kph'] as num).toDouble(),
      humidity: json['current']['humidity'],
      description: json['current']['condition']['text'],
      iconUrl: 'https:' + json['current']['condition']['icon'],
    );
  }
}
