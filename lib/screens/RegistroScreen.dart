import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:minerd/screens/LoginScreen.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  _RegistroScreenState createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _cedulaController = TextEditingController();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _claveController = TextEditingController();
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _fechaNacimientoController =
      TextEditingController();

  int _currentStep = 0; // Current step index for Stepper
  bool _isLoading = false; // Indicator for loading state

  // Simulate the registration API request
  Future<void> _register() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    final response = await http.post(
      Uri.parse('https://adamix.net/minerd/def/registro.php'),
      body: {
        'cedula': _cedulaController.text,
        'nombre': _nombreController.text,
        'apellido': _apellidoController.text,
        'clave': _claveController.text,
        'correo': _correoController.text,
        'telefono': _telefonoController.text,
        'fecha_nacimiento': _fechaNacimientoController.text,
      },
    );

    setState(() {
      _isLoading = false; // End loading
    });

    final data = jsonDecode(response.body);
    if (data['exito']) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(data['mensaje'])));
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data['mensaje']),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  // Navigate to the next step if possible
  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      // Validate the current step
      if (_currentStep < _buildSteps().length - 1) {
        // Check if not the last step
        setState(() {
          _currentStep += 1; // Advance to next step
        });
      } else {
        // If on the last step, attempt to register
        _register();
      }
    }
  }

  // Navigate to the previous step if possible
  void _previousStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep -= 1);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5FB),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/educacionbanner1.jpeg',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'REGISTRO',
                  style: TextStyle(
                    color: Color(0xFF0070D8),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Stepper(
                    type: StepperType.vertical,
                    currentStep: _currentStep,
                    onStepTapped: (step) => setState(() => _currentStep = step),
                    steps: _buildSteps(),
                    controlsBuilder:
                        (BuildContext context, ControlsDetails details) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_currentStep > 0)
                            ElevatedButton(
                              onPressed: _previousStep,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0070D8),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFF0070D8), width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Atrás',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          if (_currentStep < _buildSteps().length - 1)
                            ElevatedButton(
                              onPressed: _nextStep,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: const Color(0xFF0070D8),
                                backgroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(
                                      color: Color(0xFF0070D8), width: 2),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: const Text('Siguiente',
                                  style: TextStyle(fontSize: 16)),
                            ),
                          if (_currentStep == _buildSteps().length - 1)
                            _isLoading
                                ? const CircularProgressIndicator()
                                : ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        _register();
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor: const Color(0xFF0070D8),
                                      backgroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 40, vertical: 15),
                                      shape: RoundedRectangleBorder(
                                        side: const BorderSide(
                                            color: Color(0xFF0070D8), width: 2),
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child: const Text('Registrar',
                                        style: TextStyle(fontSize: 16)),
                                  ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF0070D8),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      side:
                          const BorderSide(color: Color(0xFF0070D8), width: 2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text('INICIAR SESIÓN',
                      style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Step> _buildSteps() {
    return [
      Step(
        title: const Text('Cédula'),
        content: _buildTextField(
          controller: _cedulaController,
          icon: Icons.person,
          hintText: 'CÉDULA',
          validator: (value) =>
              value!.isEmpty ? 'Por favor ingrese su cédula' : null,
        ),
        isActive: _currentStep >= 0, // Active step
        state: _currentStep > 0 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Nombre'),
        content: _buildTextField(
          controller: _nombreController,
          icon: Icons.person,
          hintText: 'NOMBRE',
          validator: (value) =>
              value!.isEmpty ? 'Por favor ingrese su nombre' : null,
        ),
        isActive: _currentStep >= 1,
        state: _currentStep > 1 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Apellido'),
        content: _buildTextField(
          controller: _apellidoController,
          icon: Icons.person,
          hintText: 'APELLIDO',
          validator: (value) =>
              value!.isEmpty ? 'Por favor ingrese su apellido' : null,
        ),
        isActive: _currentStep >= 2,
        state: _currentStep > 2 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Correo'),
        content: _buildTextField(
          controller: _correoController,
          icon: Icons.email,
          hintText: 'CORREO',
          validator: (value) =>
              value!.isEmpty ? 'Por favor ingrese su correo' : null,
        ),
        isActive: _currentStep >= 3,
        state: _currentStep > 3 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Teléfono'),
        content: _buildTextField(
          controller: _telefonoController,
          icon: Icons.phone,
          hintText: 'TELÉFONO',
          validator: (value) =>
              value!.isEmpty ? 'Por favor ingrese su teléfono' : null,
        ),
        isActive: _currentStep >= 4,
        state: _currentStep > 4 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Fecha de Nacimiento'),
        content: _buildTextField(
          controller: _fechaNacimientoController,
          icon: Icons.calendar_today,
          hintText: 'FECHA DE NACIMIENTO',
          validator: (value) => value!.isEmpty
              ? 'Por favor ingrese su fecha de nacimiento'
              : null,
        ),
        isActive: _currentStep >= 5,
        state: _currentStep > 5 ? StepState.complete : StepState.indexed,
      ),
      Step(
        title: const Text('Contraseña'),
        content: _buildTextField(
          controller: _claveController,
          icon: Icons.lock,
          hintText: 'CONTRASEÑA',
          obscureText: true,
          validator: (value) =>
              value!.isEmpty ? 'Por favor ingrese su contraseña' : null,
        ),
        isActive: _currentStep >= 6,
        state: _currentStep == 6 ? StepState.complete : StepState.indexed,
      ),
    ];
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hintText,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: const Color(0xFF0070D8),
        ),
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Color(0xFF0070D8),
        ),
        filled: true,
        fillColor: const Color(0xFFD9E6F2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(
            color: Color(0xFF0070D8),
            width: 2,
          ),
        ),
      ),
      style: const TextStyle(
        color: Color(0xFF0070D8),
      ),
      validator: validator,
    );
  }
}
