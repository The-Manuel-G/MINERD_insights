import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_animate/flutter_animate.dart'; // Importar la librería para animaciones
import 'package:google_fonts/google_fonts.dart'; // Importar google_fonts para personalizar las fuentes

class NoticiasScreen extends StatefulWidget {
  @override
  _NoticiasScreenState createState() => _NoticiasScreenState();
}

class _NoticiasScreenState extends State<NoticiasScreen> {
  late Future<List<Noticia>> _noticias;

  @override
  void initState() {
    super.initState();
    _noticias = fetchNoticias();
  }

  Future<List<Noticia>> fetchNoticias() async {
    final response =
        await http.get(Uri.parse('https://adamix.net/minerd/def/noticias.php'));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Noticia.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load noticias');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias',
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            )),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<List<Noticia>>(
        future: _noticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No hay noticias disponibles'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final noticia = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            NoticiaDetailScreen(noticia: noticia),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3,
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        // Imagen de la noticia con animación
                        noticia.image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                child: Image.network(
                                  noticia.image!,
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                                    .animate()
                                    .fadeIn(duration: 800.ms)
                                    .moveX(begin: -30, end: 0),
                              )
                            : Container(),

                        // Contenido de la noticia con animación
                        Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                noticia.title,
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms)
                                  .moveY(begin: -10, end: 0),
                              SizedBox(height: 8.0),
                              Text(
                                noticia.description ?? '',
                                style: GoogleFonts.roboto(
                                  textStyle: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              )
                                  .animate()
                                  .fadeIn(duration: 800.ms)
                                  .moveY(begin: 10, end: 0),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class Noticia {
  final String title;
  final String? image;
  final String? description;
  final String? content;
  final String? link;

  Noticia({
    required this.title,
    this.image,
    this.description,
    this.content,
    this.link,
  });

  factory Noticia.fromJson(Map<String, dynamic> json) {
    return Noticia(
      title: json['title'],
      image: json['image'],
      description: json['description'],
      content: json['content'],
      link: json['link'],
    );
  }
}

class NoticiaDetailScreen extends StatelessWidget {
  final Noticia noticia;

  NoticiaDetailScreen({required this.noticia});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(noticia.title,
            style: GoogleFonts.lato(
              textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            )),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            noticia.image != null
                ? Image.network(noticia.image!)
                : Container(),
            SizedBox(height: 8.0),
            Text(
              noticia.description ?? '',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              noticia.content ?? '',
              style: GoogleFonts.roboto(
                textStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                ),
              ),
            ),
            SizedBox(height: 8.0),
            noticia.link != null
                ? GestureDetector(
                    onTap: () {
                      // Implementar navegación al link externo si se desea
                    },
                    child: Text(
                      'Leer más',
                      style: TextStyle(color: Colors.blue),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
