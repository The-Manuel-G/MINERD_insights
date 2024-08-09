import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class CentrosScreen extends StatefulWidget {
  const CentrosScreen({super.key});

  @override
  _CentrosScreenState createState() => _CentrosScreenState();
}

class _CentrosScreenState extends State<CentrosScreen> {
  List<dynamic> _centros = [];
  List<dynamic> _filteredCentros = [];
  bool _isLoading = true;
  bool _hasError = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedRegion = '00'; // Valor inicial para mostrar todos los centros

  // Lista de regiones para el Dropdown
  final List<Map<String, String>> _regions = List.generate(
    18,
    (index) => {
      "code": "${index + 1}".padLeft(2, '0'),
      "name": "Región ${index + 1}"
    },
  );

  @override
  void initState() {
    super.initState();
    _fetchCentros();
    _searchController.addListener(_filterCentros);
  }

  // Método para obtener los centros desde la API
  Future<void> _fetchCentros() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse(
            'https://adamix.net/minerd/minerd/centros.php?regional=$_selectedRegion'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _centros = data['datos'];
          _filteredCentros = _centros;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  // Método para filtrar los centros según el texto ingresado
  void _filterCentros() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCentros = _centros.where((centro) {
        final nombre = centro['nombre'].toString().toLowerCase();
        final codigo = centro['codigo'].toString().toLowerCase();
        final distrito = centro['distrito'].toString().toLowerCase();
        final regional = centro['regional'].toString().toLowerCase();
        final municipio = centro['d_dmunicipal'].toString().toLowerCase();
        return nombre.contains(query) ||
            codigo.contains(query) ||
            distrito.contains(query) ||
            regional.contains(query) ||
            municipio.contains(query);
      }).toList();
    });
  }

  // Método para abrir la ubicación en el mapa
  Future<void> _openMap(double latitude, double longitude) async {
    final googleMapsUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    final appleMapsUrl = 'https://maps.apple.com/?q=$latitude,$longitude';

    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else if (await canLaunch(appleMapsUrl)) {
      await launch(appleMapsUrl);
    } else {
      throw 'Could not launch map';
    }
  }

  // Método para manejar el cambio de región
  void _onRegionChanged(String? newRegion) {
    if (newRegion != null && newRegion != _selectedRegion) {
      setState(() {
        _selectedRegion = newRegion;
        _isLoading = true;
      });
      _fetchCentros(); // Fetch new data for the selected region
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Centros Educativos',
          style: GoogleFonts.lato(
            textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Buscar por nombre, distrito, regional...',
                    hintStyle: GoogleFonts.roboto(
                      textStyle: TextStyle(color: Colors.grey[500]),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    suffixIcon:
                        const Icon(Icons.search, color: Colors.blueAccent),
                  ),
                ),
                const SizedBox(height: 10),
                // Dropdown para seleccionar la región
                DropdownButton<String>(
                  value: _selectedRegion,
                  items: [
                    const DropdownMenuItem(
                      value: '00',
                      child: Text('Todas las Regiones'),
                    ),
                    ..._regions.map((region) {
                      return DropdownMenuItem(
                        value: region['code'],
                        child: Text(region['name']!),
                      );
                    }).toList(),
                  ],
                  onChanged: _onRegionChanged,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? _buildErrorUI()
              : _buildCentrosList(),
    );
  }

  // Widget para construir la lista de centros
  Widget _buildCentrosList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _filteredCentros.length,
            itemBuilder: (context, index) {
              final centro = _filteredCentros[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  leading: const Icon(
                    Icons.school,
                    size: 50,
                    color: Colors.blueAccent,
                  ),
                  title: Text(
                    centro['nombre'],
                    style: GoogleFonts.roboto(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Código: ${centro['codigo']}',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          )),
                      Text('Distrito: ${centro['distrito']}',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          )),
                      Text('Regional: ${centro['regional']}',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          )),
                      Text('Municipio: ${centro['d_dmunicipal']}',
                          style: GoogleFonts.roboto(
                            textStyle: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 14,
                            ),
                          )),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.location_on,
                        color: Colors.redAccent),
                    onPressed: () {
                      final lat =
                          double.tryParse(centro['latitud']) ?? 0.0;
                      final long =
                          double.tryParse(centro['longitud']) ?? 0.0;
                      _openMap(lat, long);
                    },
                  ),
                ).animate().fadeIn(duration: 800.ms).moveY(begin: 30),
              );
            },
          ),
        ),
      ],
    );
  }

  // Widget para construir la UI de error
  Widget _buildErrorUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Error al cargar los datos',
            style: GoogleFonts.roboto(
              textStyle: const TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 10),
         ElevatedButton(
            onPressed: _fetchCentros,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}

