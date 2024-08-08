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
    List<VehiculoDetalleModel> data = [];
    for (int i = 0; i < items.length; i++) {
      String valueString = textFieldsValues[i].replaceAll(',', '.');
      double value = double.tryParse(valueString) ?? 0.0;
      data.add(VehiculoDetalleModel(
          vehiculo_id: widget.vehiculo.id,
          detalle_id: items[i].id,
          estado: lightStates[i],
          valor: value));
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
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return ListTile(
                        title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(item.nombre!, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        const Text("Rechazado"),
                        const SizedBox(
                            width: 10), // Espacio entre "Rechazado" y el Switch
                        Switch(
                          value: lightStates[index],
                          activeColor: Colors.blue,
                          onChanged: (bool value) {
                            setState(() {
                              lightStates[index] = value;
                            });
                          },
                        ),
                        const SizedBox(
                            width: 10), // Espacio entre el Switch y "Aprobado"
                        const Text("Aprobado"),
                      ],
                    ));
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
      ),
    );
  }
}
