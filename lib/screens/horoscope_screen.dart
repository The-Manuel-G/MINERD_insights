import 'package:flutter/material.dart';
import '../api/horoscope_api.dart';

import 'package:flutter/material.dart';

class HoroscopeScreen extends StatefulWidget {
  const HoroscopeScreen({super.key});

  @override
  _HoroscopeScreenState createState() => _HoroscopeScreenState();
}

class _HoroscopeScreenState extends State<HoroscopeScreen> {
  DateTime? _selectedDate;
  String? _zodiacSign;
  String? _horoscope;
  bool _isLoading = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _zodiacSign = HoroscopeApi.getZodiacSign(_selectedDate!);
      });
    }
  }

  Future<void> _fetchHoroscope() async {
    if (_zodiacSign != null) {
      setState(() {
        _isLoading = true;
      });

      try {
        final horoscope = await HoroscopeApi.getHoroscope(_zodiacSign!);
        setState(() {
          _horoscope = horoscope;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al obtener el horóscopo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Horóscopo Diario'),
        backgroundColor: const Color.fromARGB(255, 0, 112, 216),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Seleccionar Fecha de Nacimiento'),
            ),
            if (_selectedDate != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Fecha seleccionada: ${_selectedDate!.toLocal()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            if (_zodiacSign != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Signo del zodiaco: $_zodiacSign',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            const SizedBox(height: 20),
            if (_zodiacSign != null)
              ElevatedButton(
                onPressed: _isLoading ? null : _fetchHoroscope,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Obtener Horóscopo'),
              ),
            if (_horoscope != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  _horoscope!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
