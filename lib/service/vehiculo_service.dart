import 'dart:convert';
import 'dart:io';

import 'package:app_registro_movil/data/vehiculo_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

const storage = FlutterSecureStorage();
Future<List<VehiculoModel>> fetchVehiculos() async {
  final accessToken = await storage.read(key: 'access_token');
  final tokenType = await storage.read(key: 'token_type');
  final response = await http.get(
    Uri.parse('${dotenv.env['API_URL']}/api/vehiculos'),
    headers: {
      HttpHeaders.authorizationHeader: '$tokenType $accessToken',
      HttpHeaders.contentTypeHeader: 'application/json',
    },
  );
  final responseJson = json.decode(response.body);
  if (response.statusCode == 200) {
    final List data = responseJson['data'];
    final List<VehiculoModel> products =
        data.map((e) => VehiculoModel.fromJson(e)).toList();
    return products;
  } else {
    throw responseJson['message'];
  }
}
