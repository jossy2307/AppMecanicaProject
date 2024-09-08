import 'package:app_registro_movil/data/user_model.dart';
import 'package:app_registro_movil/service/login_service.dart';
import 'package:app_registro_movil/src/settings/settings_controller.dart';
import 'package:app_registro_movil/src/vehiculos/vehiculo_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.controller});
  final SettingsController controller;
  static const routeName = '/';
  @override
  LoginTestSnState createState() => LoginTestSnState();
}

class LoginTestSnState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> signIn() async {
    try {
      final user = await loginService(UserModel(
        email: _nameController.text,
        password: _passwordController.text,
      ));
      await storage.write(key: 'access_token', value: user.access_token);
      await storage.write(key: 'token_type', value: user.token_type);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VehiculoListView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error conexión al servidor: $e')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            // Forma de fondo superior (reducida)
            ClipPath(
              clipper: UpperWaveClipper(),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25, // Reducir tamaño de la parte superior
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                       Color.fromARGB(255, 114, 207, 235), // Azul fuerte
                       Color.fromARGB(255, 33, 151, 172),
                    ],
                  ),
                ),
              ),
            ),
            // Forma de fondo inferior (reducida)
            Align(
              alignment: Alignment.bottomCenter,
              child: ClipPath(
                clipper: LowerWaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.2, // Reducir tamaño de la parte inferior
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 114, 207, 235), // Azul fuerte
                       Color.fromARGB(255, 33, 151, 172),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Contenido principal
            
            Center( // Centrar el contenido verticalmente
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Centrar verticalmente
                  children: [
                    const Center(
                      child: Column(
                        children: [
                          Text(
                            "SEAVS",
                            style: TextStyle(
                              
                              fontSize: 40, // Tamaño reducido
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 14, 67, 77), // Color azul
                            ),
                          ),
                          Text(
                            "INICIO DE SESIÓN",
                            style: TextStyle(
                              fontSize: 20, // Tamaño más pequeño
                              color: Color.fromARGB(255, 16, 81, 119), // Color azul
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    // Formulario de inicio de sesión
                    Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Campo de usuario
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: "Usuario",
                                  labelStyle: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            // Campo de contraseña
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: TextFormField(
                                controller: _passwordController,
                                obscureText: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  labelText: "Contraseña",
                                  labelStyle: const TextStyle(color: Colors.black54),
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Botón de iniciar sesión
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    signIn();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Por favor, complete los campos.')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 226, 181, 34), // Color del botón
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 100, // Tamaño del botón
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text(
                                  'INICIAR SESIÓN',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white, // Color del texto
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter para crear la forma de onda superior
class UpperWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 50); // Ajustar la forma

    var firstControlPoint = Offset(size.width / 4, size.height - 25);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 75);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// Custom Painter para crear la forma de onda inferior
class LowerWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, 50); // Ajustar la forma

    var firstControlPoint = Offset(size.width / 4, 75);
    var firstEndPoint = Offset(size.width / 2, 50);
    path.quadraticBezierTo(
        firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);

    var secondControlPoint = Offset(size.width * 3 / 4, 25);
    var secondEndPoint = Offset(size.width, 50);
    path.quadraticBezierTo(
        secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);

    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
