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

  const DetallesPersonaScreen({super.key, required this.persona});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 112, 216),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
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
                  color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text('Teléfono: ${persona.numeroTelefono}',
                style: const TextStyle(color: Colors.black)),
            Text('Correo: ${persona.correo}',
                style: const TextStyle(color: Colors.black)),
          ],
        ),
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
        backgroundColor: const Color.fromARGB(255, 0, 112, 216),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/images/educacionbanner1.jpeg',
                width: 300, // Más grande
                height: 300, // Más grande
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Dos columnas
                    childAspectRatio:
                        3, // Reducir el tamaño de los contenedores
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: personas.length,
                  itemBuilder: (context, index) {
                    final persona = personas[index];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // Cambia la posición de la sombra
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(persona.foto),
                            radius: 30, // Reducir el tamaño del avatar
                          ),
                          const SizedBox(height: 10),
                          Text(
                            persona.nombre,
                            style: const TextStyle(
                                fontSize: 16, // Reducir el tamaño del texto
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            'Teléfono: ${persona.numeroTelefono}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                          Text(
                            'Correo: ${persona.correo}',
                            style: const TextStyle(
                                color: Colors.black, fontSize: 14),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
