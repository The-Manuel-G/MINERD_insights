
import 'package:flutter/material.dart';
class ServiciosScreen extends StatelessWidget {
  const ServiciosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('services'), // Título de la pantalla
      ),
      body: const Center(
        child:Text("Servicio") , // Mostramos el componente de presentación
      ),
    );
  }
}
