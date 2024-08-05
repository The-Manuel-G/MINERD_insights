import 'package:http/http.dart' as http;
import 'dart:convert';

class HoroscopeApi {
  static const String _url = 'https://daily-horoscope-api.p.rapidapi.com/api/Daily-Horoscope-English/?zodiacSign=aries&timePeriod=weekly';
  static const Map<String, String> _headers = {
    'x-rapidapi-key': '2247459643msh0de5caf9db88a85p18c53ajsnaea997fd635e',
    'x-rapidapi-host': 'daily-horoscope-api.p.rapidapi.com',
  };

  static Future<String> getHoroscope() async {
    final response = await http.get(Uri.parse(_url), headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['horoscope']; // Ajusta esto según la estructura de la respuesta de la API
    } else {
      throw Exception('Error al cargar los datos del horóscopo');
    }
  }
}
