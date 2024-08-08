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
  String appVersion = '';
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

  void onCompleted(BuildContext context) {
    _nameController.clear(); // Borrar el contenido del campo de nombre
    _passwordController.clear(); // Borrar el contenido del campo de contraseña
    FocusScope.of(context).unfocus(); // Cerrar el teclado virtual
  }

  Future<void> signIn() async {
    try {
      final user = await loginService(UserModel(
        email: "admin@admin.com",
        password: "password",
      ));
      await storage.write(key: 'access_token', value: user.access_token);
      await storage.write(key: 'token_type', value: user.token_type);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const VehiculoListView()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error conexion al servidor: $e')),
      );
    }
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SingleChildScrollView(
            child: !_isLoading
                ? const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: 300),
                    child: Column(children: [
                      Text("Cargando información...",
                          style: TextStyle(fontSize: 18)),
                    ]),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 70),
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: emailController,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Email"),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16),
                                child: TextFormField(
                                  controller: passwordController,
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "Password"),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 16.0),
                                child: Center(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        signIn();
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Please fill input')),
                                        );
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )),
      ),
    );
  }
}
