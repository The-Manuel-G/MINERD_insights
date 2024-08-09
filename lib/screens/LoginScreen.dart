import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'RegistroScreen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga
    });

    final response = await http.post(
      Uri.parse('https://adamix.net/minerd/def/iniciar_sesion.php'),
      body: {
        'cedula': _cedulaController.text,
        'clave': _claveController.text,
      },
    );

    setState(() {
      _isLoading = false; // Ocultar indicador de carga
    });

    final data = jsonDecode(response.body);
    if (data['exito']) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['mensaje'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/educacionbanner1.jpeg',
                  width: 200,
                  height: 200,
                ).animate().fadeIn(duration: 1000.ms),
                const SizedBox(height: 20),
                Text(
                  'INICIO',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      color: Color(0xFF0070D8),
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ).animate().fadeIn(duration: 1000.ms),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _cedulaController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Color(0xFF0070D8),
                          ),
                          hintText: 'CÉDULA',
                          hintStyle: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Color(0xFF0070D8),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD9E6F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFF0070D8),
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF0070D8),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su cédula';
                          }
                          return null;
                        },
                      ).animate().fadeIn(duration: 1000.ms),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _claveController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(
                            Icons.lock,
                            color: Color(0xFF0070D8),
                          ),
                          hintText: 'CONTRASEÑA',
                          hintStyle: GoogleFonts.lato(
                            textStyle: const TextStyle(
                              color: Color(0xFF0070D8),
                            ),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFD9E6F2),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: const BorderSide(
                              color: Color(0xFF0070D8),
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF0070D8),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese su contraseña';
                          }
                          return null;
                        },
                      ).animate().fadeIn(duration: 1000.ms),
                      const SizedBox(height: 30),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0070D8),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 100, vertical: 20),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFF0070D8), width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text(
                                'ACCEDER',
                                style: TextStyle(fontSize: 18),
                              ),
                            ).animate().fadeIn(duration: 1000.ms),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegistroScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xFF0070D8),
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                color: Color(0xFF0070D8), width: 2),
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('REGÍSTRATE',
                            style: TextStyle(fontSize: 18)),
                      ).animate().fadeIn(duration: 1000.ms),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
