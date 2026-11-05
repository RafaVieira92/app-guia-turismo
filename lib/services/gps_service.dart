import 'package:flutter/foundation.dart'; // Necessário para o debugPrint
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class GPSService {
  Future<LatLng?> obterLocal() async {
    // VER SE O GPS ESTA ATIVO
    bool ativo = await Geolocator.isLocationServiceEnabled();
    if (!ativo) {
      return null;
    }
    // VER A PERMISSÃO
    LocationPermission permissao = await Geolocator.checkPermission();
    
    // SOLICITA PERMISSÃO
    if (permissao == LocationPermission.denied) {
      permissao = await Geolocator.requestPermission();
      if (permissao == LocationPermission.denied) {
        return null;
      }
    }
    // SE NEGADA NAO HA O QUE FAZER
    if (permissao == LocationPermission.deniedForever) {
      return null;
    }
    // OBTER A LOCALIZAÇÃO 
    try {
      Position posicao = await Geolocator.getCurrentPosition();
      return LatLng(posicao.latitude, posicao.longitude);
    } catch (erro) {
      debugPrint("Erro ao obter localização: $erro");
      return null;
    }
  }
}