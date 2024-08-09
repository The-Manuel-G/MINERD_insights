import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minerd/screens/CentrosScreen.dart';
import '../../screens/AlberguesScreen.dart';
import '../../screens/Miembro.dart';
import '../../screens/ServiciosScreen.dart';
import '../../screens/VideroScreen.dart';
import '../../screens/LoginScreen.dart'; // Asegúrate de que esta ruta sea correcta
import '../../screens/ReportarVisita.dart';
import '../../screens/weather_screen.dart';
import '../../widgets/weather_widget.dart';
import '../../screens/NoticiaScreen.dart';
import '../../screens/ReportarVisita.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirmar Cierre de Sesión',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          content: const Text(
            '¿Estás seguro de que quieres cerrar sesión?',
            style: TextStyle(color: Colors.black54),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancelar',
                style: TextStyle(color: Colors.blueAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text(
                'Salir',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
            ),
          ],
        );
      },
    );
  }

  final bool isLoggedIn = false; // Define isLoggedIn

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Encabezado del Drawer con imagen y gradiente
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlueAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage(
                      'assets/images/educacionbanner1.jpeg'), // Asegúrate de tener esta imagen en tus assets
                ),
                const SizedBox(height: 10),
                const Text(
                  'Ministerio de Educación',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Educación para Todos',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Elementos del Drawer
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.school,
            text: 'Registrar incidencias',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ReporteVistaScreen()),
              );
            },
          ),

          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.school,
            text: 'Centros Educativos',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CentrosScreen()),
              );
            },
          ),

          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.wind,
            text: 'Clima',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WeatherScreen()),
              );
            },
          ),

          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.video,
            text: 'Videos',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const VideoScreen()),
              );
            },
          ),

          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.newspaper,
            text: 'Noticias',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NoticiasScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.user,
            text: 'Miembros',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AcercaDeScreen()),
              );
            },
          ),

          Divider(
            color: Colors.grey[400],
            thickness: 1.0,
            indent: 16.0,
            endIndent: 16.0,
          ),

          // Cerrar Sesión
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: isLoggedIn ? 'Cerrar Sesión' : 'Iniciar Sesión',
            onTap: () {
              if (isLoggedIn) {
                _confirmLogout(context);
              } else {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
          ),

          // Puedes agregar más ListTile para más opciones si es necesario
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: FaIcon(icon, color: Colors.blueAccent),
      title: Text(
        text,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}
