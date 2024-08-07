import 'package:flutter/material.dart';
import 'package:minerd/components/Sidebar.dart';
import 'package:minerd/screens/InicioScreen.dart';
import 'package:minerd/screens/MapaScreen.dart';
import 'package:minerd/screens/NoticiaScreen.dart';
import 'package:minerd/screens/SplashScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Welcome to Flutter',
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(
              imagePath: 'assets/splash.gif',
              duration: Duration(seconds: 4),
            ),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const InicioScreen(),
    NoticiasScreen(),
    MapaScreen()
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
        title: const Text('Welcome'),
      ),
      body: _screens[_selectedIndex],
      drawer: Sidebar(),
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
