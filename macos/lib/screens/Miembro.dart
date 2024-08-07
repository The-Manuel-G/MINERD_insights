import 'package:flutter/material.dart';

class AcercaDe {
  final String foto;
  final String nombre;
  final String numeroTelefono;
  final String correo;

  AcercaDe({
    required this.foto,
    required this.nombre,
    required this.numeroTelefono,
    required this.correo,
  });
}

class DetallesPersonaScreen extends StatelessWidget {
  final AcercaDe persona;
  final String backgroundImage;

  const DetallesPersonaScreen(
      {super.key, required this.persona, required this.backgroundImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles',
            style: TextStyle(
                color: Colors
                    .white)), // Establecer el color del texto en la barra de aplicaciones
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Image.asset(
            backgroundImage,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(persona.foto),
                  radius: 80,
                ),
                const SizedBox(height: 20),
                Text(
                  persona.nombre,
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 10),
                Text('Teléfono: ${persona.numeroTelefono}',
                    style: const TextStyle(color: Colors.white)),
                Text('Correo: ${persona.correo}',
                    style: const TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AcercaDeScreen extends StatelessWidget {
  final List<AcercaDe> personas = [
    AcercaDe(
      foto: 'assets/daniela.jpeg',
      nombre: 'Daniela Santana',
      numeroTelefono: '829-749-3374',
      correo: '20198755@itla.edu.do',
    ),
    AcercaDe(
      foto: 'assets/Manuelito.jpg',
      nombre: 'Manuel De La Cruz',
      numeroTelefono: '829-661-5050',
      correo: '20211967@itla.edu.do',
    ),
    AcercaDe(
      foto: 'assets/ariel.jpeg',
      nombre: 'Ariel Naranjo',
      numeroTelefono: '829-523-6338',
      correo: '202010742@itla.edu.do',
    ),
    AcercaDe(
      foto: 'assets/raynier.jpeg',
      nombre: 'Raynier Zorrilla',
      numeroTelefono: '829-775-9359',
      correo: '20221460@itla.edu.do',
    ),
    AcercaDe(
      foto: 'assets/carlos.jpeg',
      nombre: 'Carlos Feliz',
      numeroTelefono: '829-329-1204',
      correo: '20212322@itla.edu.do',
    ),
  ];

  AcercaDeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Acerca De',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/compu.gif',
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            fit: BoxFit.cover,
          ),
          ListView.builder(
            itemCount: personas.length,
            itemBuilder: (context, index) {
              final persona = personas[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesPersonaScreen(
                        persona: persona,
                        backgroundImage: 'assets/compu.gif',
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(persona.foto),
                  ),
                  title: Text(
                    persona.nombre,
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Teléfono: ${persona.numeroTelefono}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        'Correo: ${persona.correo}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
