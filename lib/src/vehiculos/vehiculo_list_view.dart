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
    _fetchVehiculos(); // Llama a la función para obtener los vehículos al inicio
  }

  Future<void> _fetchVehiculos() async {
  try {
    List<VehiculoModel> nuevosVehiculos = await fetchVehiculos();
    if (!mounted) return;  // Verifica si el widget está montado

    setState(() {
      items = nuevosVehiculos;
    });

    if (nuevosVehiculos.isEmpty) {
      if (mounted) {  // Verifica si el widget está montado
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No hay vehículos disponibles.')),
        );
      }
    }
  } catch (e) {
    if (mounted) {  // Verifica si el widget está montado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar lista: $e')),
      );
    }
  }
}


  Future<bool> _showLogoutConfirmationDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirmación de Cierre de Sesión'),
              content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(false); // Cierra el diálogo y retorna false
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pop(true); // Cierra el diálogo y retorna true
                  },
                  child: const Text('Cerrar Sesión'),
                ),
              ],
            );
          },
        ) ??
        false; // Retorna false si el usuario cierra el diálogo sin seleccionar una opción
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldLogout = await _showLogoutConfirmationDialog(context);
        if (shouldLogout) {
          // Redirige al login si el usuario quiere cerrar sesión
          Navigator.of(context).pushReplacementNamed('/login');
          return true;
        } else {
          // No hace nada y permanece en la pantalla
          return false;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Listado de Vehículos'),
        ),
        body: RefreshIndicator(
          onRefresh: _fetchVehiculos, // Función que se llama al refrescar
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('No hay vehículos disponibles.'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchVehiculos,
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
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
        ),
      ),
    );
  }
}
