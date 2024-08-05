import 'package:minerd/components/HomeComponent.dart';

import 'package:flutter/material.dart';
class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Presentación'), 
      ),
      body: Center(
        child:HomeComponent() , 
      ),
    );
  }
}
