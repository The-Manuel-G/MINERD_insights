import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

class ReporteVistaScreen extends StatefulWidget {
  @override
  _ReporteVistaScreenState createState() => _ReporteVistaScreenState();
}

class _ReporteVistaScreenState extends State<ReporteVistaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cedulaController = TextEditingController();
  final _codigoCentroController = TextEditingController();
  final _motivoController = TextEditingController();
  File? _foto;
  final _comentarioController = TextEditingController();
  File? _notaVoz;
  final _latitudController = TextEditingController();
  final _longitudController = TextEditingController();
  final _fechaController = TextEditingController();
  final _horaController = TextEditingController();
  final _tokenController = TextEditingController();
  int _currentIndex = 0;

  final ImagePicker _picker = ImagePicker();
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool isRecording = false;
  bool isPaused = false;
  bool isPlaying = false;
  String? _audioPath;
  AudioPlayer _audioPlayer = AudioPlayer();
  List<double> _waveformSamples = []; // Lista para almacenar muestras de audio

  PageController _pageController = PageController();

  // Variables para los menús desplegables
  String? _selectedRegion;
  String? _selectedCenter;
  List<Map<String, String>> _centers = [];
  final List<String> _regions =
      List.generate(18, (index) => (index + 1).toString().padLeft(2, '0'));

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _requestPermissions();
  }

  Future<void> _initializeRecorder() async {
    // Inicializar el grabador y configurar cualquier configuración necesaria.
    await _recorder.openRecorder();
    _recorder.setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  // Solicitar permisos al iniciar la aplicación
  Future<void> _requestPermissions() async {
    final status = await [
      Permission.camera,
      Permission.microphone,
      Permission.storage,
    ].request();

    // Verificar si todos los permisos han sido concedidos
    if (status.values.every((element) => element.isGranted)) {
      print('Todos los permisos concedidos.');
    } else {
      print('No se concedieron todos los permisos.');
    }
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _cedulaController.dispose();
    _codigoCentroController.dispose();
    _motivoController.dispose();
    _comentarioController.dispose();
    _latitudController.dispose();
    _longitudController.dispose();
    _fechaController.dispose();
    _horaController.dispose();
    _tokenController.dispose();
    _pageController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://adamix.net/minerd/minerd/registrar_visita.php'),
      );

      request.fields['cedula_director'] = _cedulaController.text;
      request.fields['codigo_centro'] = _codigoCentroController.text;
      request.fields['motivo'] = _motivoController.text;
      if (_foto != null) {
        request.files.add(
            await http.MultipartFile.fromPath('foto_evidencia', _foto!.path));
      }
      request.fields['comentario'] = _comentarioController.text;
      if (_notaVoz != null) {
        request.files
            .add(await http.MultipartFile.fromPath('nota_voz', _notaVoz!.path));
      }
      request.fields['latitud'] = _latitudController.text;
      request.fields['longitud'] = _longitudController.text;
      request.fields['fecha'] = _fechaController.text;
      request.fields['hora'] = _horaController.text;
      request.fields['token'] = _tokenController.text;

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await http.Response.fromStream(response);
        final responseJson = jsonDecode(responseData.body);
        if (responseJson['exito']) {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Visita registrada con éxito')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${responseJson['mensaje']}')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error en la solicitud')));
      }
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _foto = File(pickedFile.path);
      });
    }
  }

  Future<void> _startRecording() async {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      Directory tempDir = await getTemporaryDirectory();
      String path =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.aac';
      setState(() {
        _audioPath = path;
      });
      await _recorder.startRecorder(
        toFile: path,
        codec: Codec.aacADTS, // Asegúrate de usar un codec válido
      );
      setState(() {
        isRecording = true;
        isPaused = false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Permiso de micrófono denegado')));
    }
  }

  Future<void> _pauseRecording() async {
    await _recorder.pauseRecorder();
    setState(() {
      isPaused = true;
    });
  }

  Future<void> _resumeRecording() async {
    await _recorder.resumeRecorder();
    setState(() {
      isPaused = false;
    });
  }

  Future<void> _stopRecording() async {
    await _recorder.stopRecorder();
    setState(() {
      isRecording = false;
      isPaused = false;
      _notaVoz = File(_audioPath!);
      _loadWaveform(); // Cargar muestras de audio para mostrar la forma de onda
    });
  }

  void _playRecording() async {
    if (_notaVoz != null && !isPlaying) {
      setState(() {
        isPlaying = true;
      });
      await _audioPlayer.play(DeviceFileSource(_notaVoz!.path)).then((_) {
        setState(() {
          isPlaying = false;
        });
      });
    }
  }

  Future<void> _loadWaveform() async {
    // Cargar y procesar muestras de audio
    // Necesitas reemplazar esto con muestras reales de tu archivo de audio
    setState(() {
      _waveformSamples = List.generate(
          100, (index) => index.toDouble()); // Reemplazar con muestras reales
    });
  }

  Future<void> _fetchCenters(String region) async {
    final response = await http.get(Uri.parse(
        'https://adamix.net/minerd/minerd/centros.php?regional=$region'));

    if (response.statusCode == 200) {
      final responseJson = jsonDecode(response.body);

      if (responseJson['exito']) {
        setState(() {
          _centers = List<Map<String, String>>.from(
            responseJson['datos'].map(
              (data) => {
                'codigo': data['codigo'],
                'nombre': data['nombre'],
                'coordenadas': data['coordenadas']
              },
            ),
          );
        });
      }
    }
  }

  void _previousField() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  void _nextField() {
    if (_currentIndex < _formFields.length - 1) {
      setState(() {
        _currentIndex++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  List<Widget> get _formFields => [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _cedulaController,
              decoration: const InputDecoration(
                labelText: 'Cédula del Director',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo cédula es requerido';
                }
                return null;
              },
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: _selectedRegion,
                  decoration: const InputDecoration(
                    labelText: 'Seleccionar Región',
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                  ),
                  items: _regions.map((String region) {
                    return DropdownMenuItem<String>(
                      value: region,
                      child: Text(region),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedRegion = newValue;
                      _selectedCenter =
                          null; // Restablecer el centro al cambiar la región
                      _centers = []; // Limpiar los centros actuales
                      _codigoCentroController.clear();
                      _latitudController.clear();
                      _longitudController.clear();
                    });
                    if (newValue != null) {
                      _fetchCenters(newValue);
                    }
                  },
                ),
                const SizedBox(height: 10),
                if (_centers.isNotEmpty)
                  DropdownButtonFormField<String>(
                    value: _selectedCenter,
                    decoration: const InputDecoration(
                      labelText: 'Seleccionar Centro Educativo',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(),
                    ),
                    items: _centers.map((center) {
                      return DropdownMenuItem<String>(
                        value: center['codigo'],
                        child: Text(center['nombre']!),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedCenter = newValue;
                          final selectedCenter = _centers.firstWhere(
                              (center) => center['codigo'] == newValue);
                          _codigoCentroController.text =
                              selectedCenter['codigo']!;
                          final coordinates =
                              selectedCenter['coordenadas']!.split(',');
                          _latitudController.text = coordinates[0];
                          _longitudController.text = coordinates[1];
                        });
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _codigoCentroController,
              readOnly: true, // Hacer el campo de solo lectura
              decoration: const InputDecoration(
                labelText: 'Código del Centro',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _motivoController,
              decoration: const InputDecoration(
                labelText: 'Motivo',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo motivo es requerido';
                }
                return null;
              },
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image),
                  label: const Text('Subir Imagen',
                      style: TextStyle(fontSize: 18)),
                ),
                ElevatedButton.icon(
                  onPressed: _takePhoto,
                  icon: const Icon(Icons.camera_alt),
                  label:
                      const Text('Tomar Foto', style: TextStyle(fontSize: 18)),
                ),
                _foto == null
                    ? const Text('No se ha seleccionado una imagen',
                        style: TextStyle(fontSize: 16))
                    : Image.file(_foto!, height: 200, width: 200),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _comentarioController,
              decoration: const InputDecoration(
                labelText: 'Comentario',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo comentario es requerido';
                }
                return null;
              },
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _latitudController,
              readOnly: true, // Hacer el campo de solo lectura
              decoration: const InputDecoration(
                labelText: 'Latitud',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _longitudController,
              readOnly: true, // Hacer el campo de solo lectura
              decoration: const InputDecoration(
                labelText: 'Longitud',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo fecha es requerido';
                }
                return null;
              },
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _horaController,
              decoration: const InputDecoration(
                labelText: 'Hora',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo hora es requerido';
                }
                return null;
              },
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: TextFormField(
              controller: _tokenController,
              decoration: const InputDecoration(
                labelText: 'Token',
                labelStyle: TextStyle(fontSize: 18),
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El campo token es requerido';
                }
                return null;
              },
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              children: [
                const Text('Grabación de Audio',
                    style: TextStyle(fontSize: 16)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed:
                          isRecording ? _pauseRecording : _startRecording,
                      icon: Icon(isRecording ? Icons.pause : Icons.mic),
                    ),
                    IconButton(
                      onPressed: isPaused ? _resumeRecording : _stopRecording,
                      icon: Icon(isPaused ? Icons.play_arrow : Icons.stop),
                    ),
                  ],
                ),
                if (isRecording)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: LinearProgressIndicator(
                      value: null, // Progreso indeterminado
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                if (_notaVoz != null)
                  Column(
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: _playRecording,
                            icon: Icon(
                                isPlaying ? Icons.pause : Icons.play_arrow),
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width * 0.7,
                            child: PolygonWaveform(
                              samples: _waveformSamples,
                              height: 100,
                              width: double.infinity,
                              maxDuration: const Duration(
                                  seconds: 60), // Duración del audio
                              elapsedDuration: const Duration(
                                  seconds: 30), // Tiempo transcurrido
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Enviar'),
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reporte de Visita'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Form(
                key: _formKey,
                child: PageView.builder(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _formFields.length,
                  itemBuilder: (context, index) {
                    return Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.8,
                              child: _formFields[index],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: _previousField,
                  child: const Text('Anterior'),
                ),
                ElevatedButton(
                  onPressed: _nextField,
                  child: const Text('Siguiente'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
