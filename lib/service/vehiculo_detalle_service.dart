import 'dart:convert';
import 'dart:io';

import 'package:app_registro_movil/data/vehiculo_detalle_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();
Future<VehiculoDetalleModel> createVehiculosDetallesService(
    VehiculoDetalleModel vehiculoDetalle) async {
  final accessToken = await storage.read(key: 'access_token');
  final tokenType = await storage.read(key: 'token_type');
  final response = await http.post(
    Uri.parse('${dotenv.env['API_URL']}/api/vehiculo-detalles'),
    headers: {
      HttpHeaders.authorizationHeader: '$tokenType $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
    body: json.encode(vehiculoDetalle.toJson()),
  );

  if (response.statusCode == 201) {
    final responseJson = json.decode(response.body);
    return VehiculoDetalleModel.fromJson(
        responseJson); // Asegúrate de tener un método fromJson en tu modelo
  } else {
    throw Exception('Failed to create vehiculo detalle');
  }
}
