import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReporteVistaScreen extends StatefulWidget {
  @override
  _ReporteVistaScreenState createState() => _ReporteVistaScreenState();
}

class _ReporteVistaScreenState extends State<ReporteVistaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _codigoCentroController = TextEditingController();
  final _motivoController = TextEditingController();
  final _fotoController = TextEditingController(); // Considera usar un método para capturar fotos
  final _comentarioController = TextEditingController();
  final _notaVozController = TextEditingController(); // Considera usar un método para grabar audio
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  final _tokenController = TextEditingController(); // Podrías obtener el token de otra manera

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://adamix.net/minerd/minerd/registrar_visita.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'cedula_director': _cedulaController.text,
          'codigo_centro': _codigoCentroController.text,
          'motivo': _motivoController.text,
          'foto_evidencia': _fotoController.text,
          'comentario': _comentarioController.text,
          'nota_voz': _notaVozController.text,
          'latitud': _latitudController.text,
          'longitud': _longitudController.text,
          'fecha': _fechaController.text,
          'hora': _horaController.text,
          'token': _tokenController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['exito']) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Visita registrada con éxito')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${responseData['mensaje']}')));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error en la solicitud')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reporte de vista'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _cedulaController,
                decoration: InputDecoration(labelText: 'Cédula del Director'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo cédula es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _codigoCentroController,
                decoration: InputDecoration(labelText: 'Código del Centro'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo código centro es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _motivoController,
                decoration: InputDecoration(labelText: 'Motivo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo motivo es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fotoController,
                decoration: InputDecoration(labelText: 'Foto de Evidencia (URL)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo foto de evidencia es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _comentarioController,
                decoration: InputDecoration(labelText: 'Comentario'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo comentario es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _notaVozController,
                decoration: InputDecoration(labelText: 'Nota de Voz (URL)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo nota de voz es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _latitudController,
                decoration: InputDecoration(labelText: 'Latitud'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo latitud es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _longitudController,
                decoration: InputDecoration(labelText: 'Longitud'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo longitud es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fechaController,
                decoration: InputDecoration(labelText: 'Fecha'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo fecha es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _horaController,
                decoration: InputDecoration(labelText: 'Hora'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo hora es requerido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _tokenController,
                decoration: InputDecoration(labelText: 'Token'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'El campo token es requerido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: Text('Registrar Visita'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
