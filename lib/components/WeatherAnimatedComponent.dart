import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../api/weather_service.dart';

class WeatherAnimatedComponent extends StatefulWidget {
  @override
  _WeatherAnimatedComponentState createState() => _WeatherAnimatedComponentState();
}

class _WeatherAnimatedComponentState extends State<WeatherAnimatedComponent> {
  final WeatherService _weatherService = WeatherService();
  late Future<Map<String, dynamic>> _weatherData;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cityController.text = 'Santo Domingo'; // Ciudad predeterminada
    _fetchWeather(_cityController.text);
  }

  void _fetchWeather(String city) {
    setState(() {
      _weatherData = _weatherService.fetchWeather(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          TextField(
            controller: _cityController,
            decoration: InputDecoration(
              labelText: 'Introduce la ciudad',
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: () => _fetchWeather(_cityController.text),
              ),
            ),
            onSubmitted: (value) => _fetchWeather(value),
          ),
          const SizedBox(height: 20),
          FutureBuilder<Map<String, dynamic>>(
            future: _weatherData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator()
                    .animate()
                    .scale(duration: 500.ms)
                    .fadeIn(); // Animación de aparición
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}')
                    .animate()
                    .slide(duration: 500.ms)
                    .fadeIn(); // Animación de aparición con deslizamiento
              } else if (snapshot.hasData) {
                return _buildWeatherInfo(snapshot.data!);
              } else {
                return const Text('Introduce una ciudad para obtener el clima')
                    .animate()
                    .fadeIn(duration: 500.ms); // Animación de aparición
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo(Map<String, dynamic> weatherData) {
    final temperature = weatherData['main']['temp'];
    final condition = weatherData['weather'][0]['description'];
    final icon = weatherData['weather'][0]['icon'];
    final rain = weatherData.containsKey('rain') && weatherData['rain'].isNotEmpty;
    final rainTime = DateTime.now().add(const Duration(hours: 2));

    return Column(
      children: [
        Image.network(
          'http://openweathermap.org/img/wn/$icon@2x.png',
          scale: 0.5,
        ).animate().scale(duration: 500.ms).fadeIn(),
        Text(
          '${temperature.toStringAsFixed(1)}°C',
          style: GoogleFonts.roboto(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        )
            .animate()
            .scale(delay: 500.ms, duration: 500.ms) // Animación de escala
            .fadeIn(), // Animación de aparición gradual
        const SizedBox(height: 10),
        Text(
          condition,
          style: GoogleFonts.roboto(
            fontSize: 32,
            color: Colors.black54,
          ),
        )
            .animate()
            .move(delay: 500.ms, duration: 800.ms) // Animación de movimiento
            .fadeIn(),
        const SizedBox(height: 10),
        if (rain) ...[
          const Icon(Icons.umbrella, color: Colors.blue)
              .animate()
              .shake(delay: 700.ms, duration: 800.ms), // Animación de sacudida
          Text(
            'Lluvia posible a las ${rainTime.hour}:${rainTime.minute}',
            style: GoogleFonts.roboto(fontSize: 24, color: Colors.blueGrey),
          )
              .animate()
              .slide(delay: 700.ms, duration: 800.ms) // Animación de deslizamiento
              .fadeIn(),
        ] else ...[
          const Icon(Icons.wb_sunny, color: Colors.orange)
              .animate()
              .scale(delay: 700.ms, duration: 800.ms), // Animación de escala
          const Text(
            'No se espera lluvia hoy',
            style: TextStyle(fontSize: 24, color: Colors.green),
          )
              .animate()
              .slide(delay: 700.ms, duration: 800.ms) // Animación de deslizamiento
              .fadeIn(),
        ],
        const SizedBox(height: 20),
        _buildRecommendation(weatherData),
      ],
    );
  }

  Widget _buildRecommendation(Map<String, dynamic> weatherData) {
    final condition = weatherData['weather'][0]['main'].toLowerCase();
    String recommendation;

    if (condition.contains('rain')) {
      recommendation = 'Recuerda llevar un paraguas.';
    } else if (condition.contains('clear')) {
      recommendation = 'Es un buen día para salir a caminar.';
    } else if (condition.contains('clouds')) {
      recommendation = 'El día está nublado, viste una chaqueta ligera.';
    } else {
      recommendation = 'Mantente atento al clima, ¡podría cambiar!';
    }

    return Text(
      recommendation,
      style: GoogleFonts.roboto(fontSize: 20, color: Colors.blueAccent),
    )
        .animate()
        .fadeIn(delay: 800.ms, duration: 800.ms) // Animación de desvanecimiento
        .move(delay: 800.ms, duration: 800.ms, begin: const Offset(0, 20), end: const Offset(0, 0)); // Animación de movimiento hacia arriba
  }
}
