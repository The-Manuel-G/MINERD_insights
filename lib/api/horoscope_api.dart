import 'package:http/http.dart' as http;
import 'dart:convert';

class HoroscopeApi {
  static const String _baseUrl = 'https://daily-horoscope-api.p.rapidapi.com/api/Daily-Horoscope-English/';

  static const Map<String, String> _headers = {
    'x-rapidapi-key': '2247459643msh0de5caf9db88a85p18c53ajsnaea997fd635e',
    'x-rapidapi-host': 'daily-horoscope-api.p.rapidapi.com',
  };

  static Future<String> getHoroscope(String zodiacSign, {String timePeriod = 'weekly'}) async {
    final url = '$_baseUrl?zodiacSign=$zodiacSign&timePeriod=$timePeriod';
    
    final response = await http.get(Uri.parse(url), headers: _headers);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['data']['horoscope']; // Ajusta esto según la estructura de la respuesta de la API
    } else {
      throw Exception('Error al cargar los datos del horóscopo');
    }
  }

  /// Determina el signo del zodiaco basado en el mes y el día de nacimiento
  static String getZodiacSign(DateTime birthDate) {
    int month = birthDate.month;
    int day = birthDate.day;

    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'aquarius';
    } else if ((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
      return 'pisces';
    } else if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'aries';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'taurus';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'gemini';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'cancer';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'leo';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'virgo';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'libra';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'scorpio';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'sagittarius';
    } else {
      return 'capricorn';
    }
  }
}
