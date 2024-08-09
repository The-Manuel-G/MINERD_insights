import 'package:flutter/material.dart';
import 'package:minerd/screens/LoginScreen.dart';
import 'package:minerd/screens/RegistroScreen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Cambia la carga de la imagen
              Image.asset(
                'assets/images/educacionbanner1.jpeg', // Asegúrate de que esta ruta sea correcta y que la imagen esté en el directorio "assets"
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: const Color(0xFF0070D8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('INICIO', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const RegistroScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0070D8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 90, vertical: 20),
                  side: const BorderSide(
                      color: Color(0xFF0070D8), width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('REGISTRO', style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

