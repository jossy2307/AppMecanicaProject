import 'package:app_registro_movil/data/vehiculo_model.dart';
import 'package:app_registro_movil/service/vehiculo_service.dart';
import 'package:app_registro_movil/src/vehiculos/vehiculo_detail_view.dart';
import 'package:flutter/material.dart';

class VehiculoListView extends StatefulWidget {
  const VehiculoListView({super.key});

  @override
  State<VehiculoListView> createState() => _VehiculoListViewState();
}

class _VehiculoListViewState extends State<VehiculoListView> {
  late List<VehiculoModel> items = List.empty();

  @override
  void initState() {
    super.initState();
    fetchVehiculos().then((value) => setState(() {
          items = value;
        }));
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de Vehiculos'),
      ),
      body: items.isEmpty
          ? const Center(
              child: Text('No hay vehículos disponibles.'),
            )
          : ListView.builder(
              restorationId: 'sampleItemListView',
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                final item = items[index];

                return ListTile(
                  title: Text(' ${item.placa} '),
                  leading: const CircleAvatar(
                    // Display the Flutter Logo image asset.
                    foregroundImage:
                        AssetImage('assets/images/flutter_logo.png'),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            VehiculoDetailView(vehiculo: item)),
                  ),
                );
              },
            ),
    );
  }
}
