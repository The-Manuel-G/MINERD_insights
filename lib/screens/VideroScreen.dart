
import 'package:flutter/material.dart';
class VideoScreen extends StatelessWidget {
  const VideoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('video'), // Título de la pantalla
      ),
      body: const Center(
        child:Text("video"), // Mostramos el componente de presentación
      ),
    );
  }
}
