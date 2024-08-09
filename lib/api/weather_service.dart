import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey =
      '3f41d4adf153a79898059e89255d9e13'; // Reemplaza con tu clave API de OpenWeatherMap

  // Método para obtener el clima actual
  Future<Map<String, dynamic>> fetchWeather(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=es'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se pudo obtener los datos del clima');
    }
  }

  // Método para obtener el pronóstico del clima
  Future<Map<String, dynamic>> fetchForecast(String city) async {
    final response = await http.get(
      Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&appid=$apiKey&units=metric&lang=es'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('No se pudo obtener los datos del pronóstico');
    }
  }
}
