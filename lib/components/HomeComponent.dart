import 'package:flutter/material.dart';
import 'package:minerd/screens/Miembro.dart';

import '../screens/horoscope_screen.dart';

class HomeComponent extends StatelessWidget {
  const HomeComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            color: Colors.blueAccent,
            child: const Column(
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.report_problem,
                        color: Colors.blueAccent),
                    title: const Text('Registros de Incidencias'),
                    subtitle: const Text(
                        'Accede a nuestros registros de incidencias disponibles.'),
                    onTap: () {
                      // Navegar a la página de registros de incidencias
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.video_library,
                        color: Colors.blueAccent),
                    title: const Text('Videos'),
                    subtitle: const Text('Mira videos de centros educativos'),
                    onTap: () {
                      // Navegar a la página de videos
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.casino, color: Colors.blueAccent),
                    title: const Text('Horóscopo'),
                    subtitle: const Text('Consulta tu horóscopo diario.'),
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
                    leading: const Icon(Icons.contact_support,
                        color: Colors.blueAccent),
                    title: const Text('Acerca de'),
                    subtitle:
                        const Text('Contacta a nuestro equipo de soporte.'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AcercaDeScreen()));
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
