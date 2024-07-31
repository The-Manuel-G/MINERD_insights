import '../../screens/AlberguesScreen.dart';
import '../../screens/HistoriaScreen.dart';
import '../../screens/MedidaPreventivaScreen.dart';
import '../../screens/Miembro.dart';
import '../../screens/ServiciosScreen.dart';
import '../../screens/VideroScreen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Sidebar Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.history), // Corrected icon for "Historia"
            title: Text('Historia'),
            onTap: () {
              Navigator.pop(context); // Cierra el sidebar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoriaScreen()),
              );
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.newspaper), // Icono para "Servicios"
            title: Text('Servicios'),
            onTap: () {
              Navigator.pop(context); // Cierra el sidebar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiciosScreen()),
              );
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.video), // Icono para "Videos"
            title: Text('Videos'),
            onTap: () {
              Navigator.pop(context); // Cierra el sidebar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VideoScreen()),
              );
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.hospital), // Icono para "Albergues"
            title: Text('Albergues'),
            onTap: () {
              Navigator.pop(context); // Cierra el sidebar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AlberguesScreen()),
              );
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.shieldAlt), // Icono para "Medida Preventiva"
            title: Text('Medida Preventiva'),
            onTap: () {
              Navigator.pop(context); // Cierra el sidebar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MedidaPreventivaScreen()),
              );
            },
          ),
          ListTile(
            leading: FaIcon(FontAwesomeIcons.user), // Icono para "Miembros"
            title: Text('Miembros'),
            onTap: () {
              Navigator.pop(context); // Cierra el sidebar
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MiembroScreen()),
              );
            },
          ),
          // Puedes agregar más ListTile para más opciones si es necesario
        ],
      ),
    );
  }
}
