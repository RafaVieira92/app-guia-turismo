import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:provider/provider.dart';
import 'package:mapas/controllers/gps_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _mostrarDialogCadastro(BuildContext context) {
    final TextEditingController enderecoController = TextEditingController();
    final mapaController = Provider.of<GPSController>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cadastrar Novo Lugar'),
          content: TextField(
            controller: enderecoController,
            decoration: const InputDecoration(
              hintText: 'Digite o endereço, cidade ou CEP',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                mapaController.buscarEAdicionarEndereco(
                  enderecoController.text,
                );
                Navigator.pop(context); 
              },
              child: const Text('Buscar e Salvar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogCadastro(context),
        child: const Icon(Icons.add_location_alt),
      ),
      body: Consumer<GPSController>(
        builder: (context, mapaController, child) => SafeArea(
          child: Column(
            children: [

              if (mapaController.erro != null &&
                  mapaController.erro!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    mapaController.erro!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              mapaController.carregando
                  ? const Expanded(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : mapaController.atual == null
                  ? const Expanded(
                      child: Center(child: Text("Localização não encontrada")),
                    )
                  : Expanded(
                      child: FlutterMap(
                        options: MapOptions(
                          initialZoom: 15.0,
                          initialCenter: mapaController.atual!,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: "br.com.maps",
                          ),
                          MarkerLayer(
                            markers: mapaController.pontos
                                .map(
                                  (ponto) => Marker(
                                    alignment: Alignment.center,
                                    width: 40,
                                    height: 40,
                                    rotate: true,
                                    point: ponto,
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 40,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
