// lib/weather_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static const String _apiKey = "54d6d1359c044af0bd1171918250908";
  static const String _baseUrl = "https://api.weatherapi.com/v1/forecast.json?key=$_apiKey&q=";
  static String cityName = "Islamabad";
  static void setCity(String newCity){
    cityName=newCity;
  }
  /// Static method to fetch weather data by city name
  static Future<Map<String, dynamic>?> fetchWeatherByCity() async {
    print(cityName);
    try {
      final url = Uri.parse("$_baseUrl$cityName&days=5");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error fetching weather: ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      print("Exception in fetchWeatherByCity: $e");
      return null;
    }
  }
}
