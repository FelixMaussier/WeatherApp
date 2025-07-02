import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';

class WeatherService {
  final String apiKey = 'd617ba1da1f74a9593c195238250207';
  final String baseUrl = 'http://api.weatherapi.com/v1/';

  String buildWeatherUrl(String city) {
    return 'http://api.weatherapi.com/v1/current.json?key=$apiKey&q=$city&aqi=no';
  }

  Future<Weather?> fetchWeather(String city) async {
    final url = Uri.parse(buildWeatherUrl(city));

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else {
        print('API error: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Request failed: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>> fetchWeatherAsMap(String city) async {
    final url = buildWeatherUrl(city);
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Kunde inte hämta väderdata');
    }
  }
}
