import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:mapas/services/gps_service.dart';

class GPSController extends ChangeNotifier {
  final GPSService _servico = GPSService();

  LatLng? atual;
  List<LatLng> historico = [];
  bool carregando = false;
  String? erro = "";

  List<LatLng> get pontos => historico;

  GPSController() {
    obterLocal();
  }

  Future<void> obterLocal() async {
    carregando = true;
    notifyListeners();

    try {
      atual = await _servico.obterLocal();
      if (atual != null) {
        erro = null;
        historico.add(atual!);
      } else {
        erro = "Erro ao buscar localização.";
      }
    } catch (e) {
      erro = e.toString();
      debugPrint("Erro: $erro");
    } finally {
      carregando = false;
      notifyListeners();
    }
  }

  Future<void> buscarEAdicionarEndereco(String endereco) async {
    if (endereco.isEmpty) return;

    carregando = true;
    notifyListeners();

    try {
      final url = Uri.parse(
        'https://nominatim.openstreetmap.org/search?q=$endereco&format=json&limit=1',
      );

      final response = await http.get(
        url,
        headers: {'User-Agent': 'AppGuiaTurismoFatec/1.0'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          final novoPonto = LatLng(lat, lon);

          historico.add(novoPonto); 
          atual = novoPonto; 
          erro = null;
        } else {
          erro = "Endereço ou CEP não encontrado.";
        }
      }
    } catch (e) {
      erro = "Erro na busca: $e";
      debugPrint(erro);
    } finally {
      carregando = false;
      notifyListeners();
    }
  }
}
