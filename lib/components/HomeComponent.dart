import 'package:flutter/material.dart';

import '../screens/horoscope_screen.dart';

class HomeComponent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(20.0),
            color: Colors.blueAccent,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bienvenido a la Aplicación del Ministerio de educacuión',
                  style: TextStyle(
                    fontSize: 24.0,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Registra incidencias y accede a información de centros educativos.',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading:
                        Icon(Icons.report_problem, color: Colors.blueAccent),
                    title: Text('Registros de Incidencias'),
                    subtitle: Text(
                        'Accede a nuestros registros de incidencias disponibles.'),
                    onTap: () {
                      // Navegar a la página de registros de incidencias
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading:
                        Icon(Icons.video_library, color: Colors.blueAccent),
                    title: Text('Videos'),
                    subtitle: Text('Mira videos de centros educativos'),
                    onTap: () {
                      // Navegar a la página de videos
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: Icon(Icons.casino, color: Colors.blueAccent),
                    title: Text('Horóscopo'),
                    subtitle: Text('Consulta tu horóscopo diario.'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HoroscopeScreen()),
                      );
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading:
                        Icon(Icons.contact_support, color: Colors.blueAccent),
                    title: Text('Acerca de'),
                    subtitle: Text('Contacta a nuestro equipo de soporte.'),
                    onTap: () {
                      // Navegar a la página de soporte
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
