import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

class WeatherWidget extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherWidget({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    final temperature = weatherData['main']['temp'];
    final condition =
        weatherData['weather'][0]['description']; // Descripción del clima
    final rain = weatherData.containsKey('rain') &&
        weatherData['rain'].isNotEmpty; // Chequeo si hay lluvia
    final rainTime =
        DateTime.now().add(Duration(hours: 2)); // Hora estimada de lluvia

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${temperature.toStringAsFixed(1)}°C',
            style: GoogleFonts.roboto(
              fontSize: 64,
              fontWeight: FontWeight.bold,
            ),
          )
              .animate()
              .scale(delay: 500.ms, duration: 500.ms) // Animación de escala
              .fadeIn(), // Animación de aparición gradual
          SizedBox(height: 20),
          Text(
            condition,
            style: GoogleFonts.roboto(fontSize: 32),
          )
              .animate()
              .move(delay: 500.ms, duration: 800.ms) // Animación de movimiento
              .fadeIn(),
          if (rain) ...[
            SizedBox(height: 20),
            Text(
              'Lluvia posible a las ${rainTime.hour}:${rainTime.minute}',
              style: GoogleFonts.roboto(fontSize: 24),
            )
                .animate()
                .slide(
                    delay: 700.ms,
                    duration: 800.ms) // Animación de deslizamiento
                .fadeIn(),
          ] else ...[
            SizedBox(height: 20),
            Text(
              'No se espera lluvia hoy',
              style: GoogleFonts.roboto(fontSize: 24),
            )
                .animate()
                .slide(
                    delay: 700.ms,
                    duration: 800.ms) // Animación de deslizamiento
                .fadeIn(),
          ]
        ],
      ),
    );
  }
}
