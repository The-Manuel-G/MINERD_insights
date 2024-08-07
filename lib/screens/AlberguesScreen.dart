
import 'package:flutter/material.dart';
class AlberguesScreen extends StatelessWidget {
  const AlberguesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentación'), // Título de la pantalla
      ),
      body: const Center(
        child:Text("albergue"), // Mostramos el componente de presentación
      ),
    );
  }
}
