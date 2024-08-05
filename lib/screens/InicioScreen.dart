import 'package:flutter/material.dart';
import '../../components/HomeComponent.dart';
import '../../components/BannerComponent.dart'; // Asegúrate de importar el BannerComponent

class InicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight:
                200.0, // Ajusta la altura del AppBar según sea necesario
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: BannerComponent(), // Incluye el BannerComponent aquí
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                HomeComponent(), // Agrega el HomeComponent aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}
