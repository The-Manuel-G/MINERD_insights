import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RecoverPassScreen extends StatefulWidget {
  const RecoverPassScreen({super.key});

  @override
  _RecoverPassScreenState createState() => _RecoverPassScreenState();
}

class _RecoverPassScreenState extends State<RecoverPassScreen> {
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  Future<void> _recoverPassword() async {
    final response = await http.post(
      Uri.parse('https://adamix.net/minerd/def/recuperar_clave.php'),
      body: {
        'cedula': _cedulaController.text, // Incluye el campo cédula si es requerido
        'correo': _emailController.text,  // Incluye el campo correo
      },
    );

    final data = jsonDecode(response.body);
    if (data['exito']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Correo enviado con éxito')),
      );
      Navigator.pop(context); // Volver a la pantalla anterior (LoginScreen)
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['mensaje'])),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar Contraseña'),
        backgroundColor: const Color.fromARGB(255, 0, 112, 216),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Introduce tu cédula y correo para recuperar tu contraseña',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _cedulaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Cédula',
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Correo electrónico',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _recoverPassword,
                child: const Text('Recuperar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
