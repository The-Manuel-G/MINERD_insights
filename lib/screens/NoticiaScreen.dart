import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    final response = await http.get(Uri.parse('https://adamix.net/minerd/def/noticias.php'));

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
        title: Text('Noticias'),
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
                return ListTile(
                  contentPadding: EdgeInsets.all(8.0),
                  title: Text(noticia.title),
                  leading: noticia.image != null
                      ? Image.network(noticia.image!, width: 50, height: 50, fit: BoxFit.cover)
                      : null,
                  subtitle: Text(noticia.description ?? ''),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoticiaDetailScreen(noticia: noticia),
                      ),
                    );
                  },
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
        title: Text(noticia.title),
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(noticia.content ?? ''),
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

