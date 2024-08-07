import 'package:flutter/material.dart';
import '../../components/HomeComponent.dart';
import '../../components/BannerComponent.dart'; // Asegúrate de importar el BannerComponent

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(
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
                const HomeComponent(), // Agrega el HomeComponent aquí
              ],
            ),
          ),
        ],
      ),
    );
  }
}
