import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:minerd/main.dart';
import 'token.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Importa google_fonts para fuentes modernas
import 'package:flutter_animate/flutter_animate.dart'; // Importa flutter_animate para animaciones

class AccederScreen extends StatelessWidget {
  const AccederScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  late String _identification;
  late String _password;
  bool _isLoading = false;

  Future<void> _iniciarSesion() async {
    setState(() {
      _isLoading = true; // Muestra el indicador de carga
    });

    final url = Uri.parse('https://adamix.net/minerd/def/iniciar_sesion.php');
    final response = await http.post(url, body: {
      'cedula': _identification,
      'clave': _password,
    });

    setState(() {
      _isLoading = false; // Oculta el indicador de carga
    });

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final bool success = responseData['exito'];
      if (kDebugMode) {
        print(responseData);
      }
      if (success) {
        TokenApi tokenApi = TokenApi();
        final String token = responseData['datos']['token'];
        tokenApi.token = token;

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      } else {
        final String errorMessage = responseData['mensaje'];
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ));
      }
    } else {
      if (kDebugMode) {
        print('Error en el inicio de sesión: ${response.body}');
      }
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error en el servidor, intenta de nuevo.'),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Cédula',
              labelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(color: Colors.grey[700]),
              ),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.account_circle),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu cédula';
              }
              return null;
            },
            onSaved: (value) {
              _identification = value!;
            },
          ).animate().fadeIn(duration: 500.ms), // Animación de entrada suave
          const SizedBox(height: 20),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Clave',
              labelStyle: GoogleFonts.roboto(
                textStyle: TextStyle(color: Colors.grey[700]),
              ),
              border: const OutlineInputBorder(),
              prefixIcon: const Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor ingresa tu contraseña';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ).animate().fadeIn(duration: 500.ms), // Animación de entrada suave
          const SizedBox(height: 20),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(), // Indicador de carga
                )
              : ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _iniciarSesion();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  ),
                  child: const Text('Iniciar sesión'),
                ).animate().fadeIn(duration: 500.ms), // Animación de entrada suave
        ],
      ),
    );
  }
}
