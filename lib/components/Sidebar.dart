import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../screens/AlberguesScreen.dart';
import '../../screens/HistoriaScreen.dart';
import '../../screens/MedidaPreventivaScreen.dart';
import '../../screens/Miembro.dart';
import '../../screens/ServiciosScreen.dart';
import '../../screens/VideroScreen.dart';
import '../../screens/LoginScreen.dart'; // Asegúrate de que esta ruta sea correcta
import '../../screens/ChangePasswordScreen.dart'; 

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Cierre de Sesión'),
          content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
            ),
            TextButton(
              child: const Text('Salir'),
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
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 0, 112, 216), // Estilo de color del login
            ),
            child: Text(
              'Sidebar Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.history,
            text: 'Historia',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriaScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.newspaper,
            text: 'Servicios',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ServiciosScreen()),
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
            icon: FontAwesomeIcons.hospital,
            text: 'Albergues',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AlberguesScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: FontAwesomeIcons.shieldAlt,
            text: 'Medida Preventiva',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedidaPreventivaScreen()),
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
          _buildDrawerItem(
            context,
            icon: Icons.password,
            text: 'Cambiar Contraseña',
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),
          _buildDrawerItem(
            context,
            icon: Icons.logout,
            text: 'Cerrar Sesión',
            onTap: () {
              _confirmLogout(context);
            },
          ),
          if (!isLoggedIn)
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Acceder'),
              tileColor: Colors.blue,
              textColor: Colors.white,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()), // Asegúrate de que 'LoginScreen' esté definido en tu proyecto
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context,
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: FaIcon(icon, color: const Color.fromARGB(255, 0, 112, 216)), // Estilo de color del login
      title: Text(
        text,
        style: const TextStyle(color: Color.fromARGB(255, 0, 112, 216)), // Estilo de color del login
      ),
      onTap: onTap,
    );
  }
}
