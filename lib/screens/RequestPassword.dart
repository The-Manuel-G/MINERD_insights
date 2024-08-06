import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangePasswordScreen(),
    );
  }
}

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tokenController = TextEditingController();
  final _claveAnteriorController = TextEditingController();
  final _claveNuevaController = TextEditingController();

  void _cambiarClave() async {
    if (_formKey.currentState!.validate()) {
      final token = _tokenController.text;
      final claveAnterior = _claveAnteriorController.text;
      final claveNueva = _claveNuevaController.text;

      try {
        await cambiarClave(token, claveAnterior, claveNueva);
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cambiar Contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(labelText: 'Token'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese el token';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _claveAnteriorController,
                decoration: InputDecoration(labelText: 'Clave Anterior'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la clave anterior';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _claveNuevaController,
                decoration: InputDecoration(labelText: 'Clave Nueva'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Por favor ingrese la clave nueva';
                  }
                  return null;
                },
                obscureText: true,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _cambiarClave,
                child: Text('Cambiar Contraseña'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> cambiarClave(String token, String claveAnterior, String claveNueva) async {
  final url = 'https://adamix.net/minerd/def/cambiar_clave.php'; //API

  final response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'token': token,
      'clave_anterior': claveAnterior,
      'clave_nueva': claveNueva,
    }),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    if (data['exito']) {
      print('Contraseña cambiada exitosamente');
    } else {
      print('Error al cambiar la contraseña: ${data['mensaje']}');
    }
  } else {
    print('Error en la solicitud: ${response.statusCode}');
  }
}
