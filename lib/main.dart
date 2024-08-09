import 'package:flutter/material.dart';
import 'package:minerd/components/Sidebar.dart';
import 'package:minerd/screens/RegistroScreen.dart';
import 'package:minerd/screens/InicioScreen.dart';
import 'package:minerd/screens/MapaScreen.dart';
import 'package:minerd/screens/NoticiaScreen.dart';
import 'package:minerd/screens/SplashScreen.dart';
import 'package:minerd/screens/auth_screen.dart';
import 'package:minerd/screens/horoscope_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bienvenido a Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(
              imagePath:
                  'data:image/png;base64,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',
              duration: Duration(seconds: 4),
            ),
        '/home': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/registro': (context) => const RegistroScreen(),
// Añade la ruta de la pantalla de clima
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InicioScreen(),
    NoticiasScreen(),
    MapaScreen(),
    HoroscopeScreen(),
     // Añade la pantalla de clima al índice de navegación
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenido'),
      ),
      body: _screens[_selectedIndex],
      drawer: const Sidebar(),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article),
            label: 'Noticias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Mapas',
          ),
          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
