import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../api/weather_service.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherService _weatherService = WeatherService();
  late Future<Map<String, dynamic>> _currentWeather;
  late Future<Map<String, dynamic>> _forecastWeather;
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cityController.text = 'Santo Domingo'; // Ciudad predeterminada
    _currentWeather = _weatherService.fetchWeather(_cityController.text);
    _forecastWeather = _weatherService.fetchForecast(_cityController.text);
  }

  void _fetchWeather(String city) {
    setState(() {
      _currentWeather = _weatherService.fetchWeather(city);
      _forecastWeather = _weatherService.fetchForecast(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildSearchBar(),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: _currentWeather,
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
                    return const Text(
                            'Introduce una ciudad para obtener el clima')
                        .animate()
                        .fadeIn(duration: 500.ms); // Animación de aparición
                  }
                },
              ),
              const SizedBox(height: 20),
              FutureBuilder<Map<String, dynamic>>(
                future: _forecastWeather,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator()
                        .animate()
                        .scale(duration: 500.ms)
                        .fadeIn();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}')
                        .animate()
                        .slide(duration: 500.ms)
                        .fadeIn();
                  } else if (snapshot.hasData) {
                    return _buildForecast(snapshot.data!);
                  } else {
                    return const Text('No se pudo obtener el pronóstico')
                        .animate()
                        .fadeIn(duration: 500.ms);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      controller: _cityController,
      decoration: InputDecoration(
        labelText: 'Introduce la ciudad',
        labelStyle: GoogleFonts.roboto(color: Colors.grey[600]),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          color: Colors.lightBlue,
          onPressed: () => _fetchWeather(_cityController.text),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onSubmitted: (value) => _fetchWeather(value),
    );
  }

  Widget _buildWeatherInfo(Map<String, dynamic> weatherData) {
    final temperature = weatherData['main']['temp'];
    final condition = weatherData['weather'][0]['description'];
    final icon = weatherData['weather'][0]['icon'];
    final humidity = weatherData['main']['humidity'];
    final windSpeed = weatherData['wind']['speed'];
    final formattedDate =
        DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/icons/${_getWeatherIcon(icon)}.svg',
            height: 150,
            width: 150,
          ).animate().scale(duration: 500.ms).fadeIn(),
          const SizedBox(height: 10),
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
          Text(
            formattedDate,
            style: GoogleFonts.roboto(
              fontSize: 20,
              color: Colors.black54,
            ),
          ).animate().fadeIn(),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildWeatherDetail(Icons.water_drop, '$humidity%', 'Humedad'),
              _buildWeatherDetail(Icons.air, '$windSpeed m/s', 'Viento'),
            ],
          ),
          const SizedBox(height: 20),
          _buildRecommendation(weatherData),
        ],
      ),
    );
  }

  Widget _buildWeatherDetail(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 40),
        const SizedBox(height: 5),
        Text(
          value,
          style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: GoogleFonts.roboto(fontSize: 16, color: Colors.black54),
        ),
      ],
    )
        .animate()
        .slide(delay: 700.ms, duration: 800.ms) // Animación de deslizamiento
        .fadeIn();
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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Text(
        recommendation,
        style: GoogleFonts.roboto(fontSize: 20, color: Colors.blueAccent),
        textAlign: TextAlign.center,
      ).animate().fadeIn(delay: 800.ms, duration: 800.ms),
    );
  }

  Widget _buildForecast(Map<String, dynamic> forecastData) {
    final List<dynamic> forecastList = forecastData['list'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pronóstico para los próximos 5 días',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ).animate().fadeIn(),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecastList.length,
            itemBuilder: (context, index) {
              final forecast = forecastList[index];
              final dateTime =
                  DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
              final icon = forecast['weather'][0]['icon'];
              final temperature = forecast['main']['temp'];
              final time = DateFormat('E, h a').format(dateTime);

              return Card(
                color: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: GoogleFonts.roboto(
                            fontSize: 16, color: Colors.white),
                      ),
                      SvgPicture.asset(
                        'assets/icons/${_getWeatherIcon(icon)}.svg',
                        height: 50,
                        width: 50,
                      ),
                      Text(
                        '${temperature.toStringAsFixed(1)}°C',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: (index * 100).ms);
            },
          ),
        ),
      ],
    );
  }

  String _getWeatherIcon(String iconCode) {
    switch (iconCode) {
      case '01d':
        return 'sunny';
      case '01n':
        return 'night';
      case '02d':
      case '02n':
        return 'partly_cloudy';
      case '03d':
      case '03n':
      case '04d':
      case '04n':
        return 'cloudy';
      case '09d':
      case '09n':
        return 'rainy';
      case '10d':
      case '10n':
        return 'rain';
      case '11d':
      case '11n':
        return 'storm';
      case '13d':
      case '13n':
        return 'snow';
      case '50d':
      case '50n':
        return 'fog';
      default:
        return 'unknown';
    }
  }
}
