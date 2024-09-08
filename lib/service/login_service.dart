import 'dart:convert';
import 'dart:io';

import 'package:app_registro_movil/data/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
Future<UserModel> loginService(UserModel vehiculoDetalle) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['API_URL']}/api/login'),
    headers: {
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: json.encode(vehiculoDetalle.toJson()),
  );

  if (response.statusCode == 200) {
    final responseJson = json.decode(response.body);
    return UserModel.fromJson(responseJson); // Asegúrate de tener un método fromJson en tu modelo
  } else {
    throw Exception('Error al crear el detalle del vehículo');
  }
}
 