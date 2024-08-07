import 'package:flutter/material.dart';
import '../api/horoscope_api.dart';

class HoroscopeScreen extends StatefulWidget {
  @override
  _HoroscopeScreenState createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  String _horoscope = 'Cargando...';

  @override
  void initState() {
    super.initState();
    fetchHoroscope();
  }

  Future<void> fetchHoroscope() async {
    try {
      final horoscope = await HoroscopeApi.getHoroscope();
      setState(() {
        _horoscope = horoscope;
      });
    } catch (e) {
      setState(() {
        _horoscope = 'Error al cargar los datos del horóscopo: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horóscopo'),
      ),
      body: Center(
        child: Text(_horoscope),
      ),
    );
  }
}
