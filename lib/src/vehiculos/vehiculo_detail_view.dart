import 'dart:math';

import 'package:app_registro_movil/data/detalle_model.dart';
import 'package:app_registro_movil/data/vehiculo_detalle_model.dart';
import 'package:app_registro_movil/data/vehiculo_model.dart';
import 'package:app_registro_movil/service/detalles_service.dart';
import 'package:app_registro_movil/service/vehiculo_detalle_service.dart';
import 'package:app_registro_movil/src/vehiculos/vehiculo_list_view.dart';
import 'package:flutter/material.dart';

class VehiculoDetailView extends StatefulWidget {
  const VehiculoDetailView({super.key, required this.vehiculo});
  final VehiculoModel vehiculo;
  @override
  State<VehiculoDetailView> createState() => _VehiculoDetailViewState();
}

class _VehiculoDetailViewState extends State<VehiculoDetailView> {
  late List<DetalleModel> items = List.empty();
  List<String?> observaciones =
      List.generate(10, (index) => null); // Lista para guardar observaciones
  bool light = true;
  List<bool> lightStates = [];
  List<String> textFieldsValues = [];
  @override
  void initState() {
    super.initState();
    fetchDetalles().then((value) => setState(() {
          items = value;
          lightStates = List<bool>.filled(value.length, false);
          textFieldsValues = List<String>.filled(value.length, '');
        }));
  }

  void validateToSave() {
    // Mostrar un diálogo de confirmación antes de proceder
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar'),
          content: const Text(
              '¿Estás seguro de que deseas enviar esta información?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cierra el diálogo
                // Si se confirma, proceder con la operación de guardado
                _saveData();
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _saveData() {
    List<VehiculoDetalleModel> data = [];
    for (int i = 0; i < items.length; i++) {
      String valueString = textFieldsValues[i].replaceAll(',', '.');
      double value = double.tryParse(valueString) ?? 0.0;
      data.add(VehiculoDetalleModel(
        vehiculo_id: widget.vehiculo.id,
        detalle_id: items[i].id,
        estado: lightStates[i],
        valor: value,
        descripcion: !lightStates[i]
            ? observaciones[i]
            : null, // Solo agrega la observación si está rechazado
      ));
    }

    try {
      // Envía 'data' a tu backend o haz lo que sea necesario con los datos
      for (var element in data) {
        
        createVehiculosDetallesService(element);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registro agregado correctamente')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al agregar registro: $e')),
      );
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const VehiculoListView()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detalles - ${widget.vehiculo.placa}'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                restorationId: 'sampleItemListView',
                itemCount: lightStates.length,
                itemBuilder: (BuildContext context, int index) {
                  final item = items[index];
                  return StatefulBuilder(
                    builder: (BuildContext context, StateSetter setState) {
                      return Column(
                        children: [
                          ListTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(item.nombre!,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                                const Text("Rechazado"),
                                const SizedBox(
                                    width:
                                        10), // Espacio entre "Rechazado" y el Switch
                                Switch(
                                  value: lightStates[index],
                                  activeColor: Colors.blue,
                                  onChanged: (bool value) {
                                    setState(() {
                                      lightStates[index] = value;
                                      if (value) {
                                        observaciones[index] =
                                            null; // Limpiar observación si se aprueba
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(
                                    width:
                                        10), // Espacio entre el Switch y "Aprobado"
                                const Text("Aprobado"),
                              ],
                            ),
                          ),
                          if (!lightStates[
                              index]) // Mostrar input si está rechazado
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextField(
                                onChanged: (text) {
                                  observaciones[index] = text;
                                },
                                decoration: const InputDecoration(
                                  labelText: 'Observación',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () => validateToSave(),
                child: const Text('Guardar'),
              ),
            ),
          ],
        ));
  }
}
