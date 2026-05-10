// lib/services/core/api_config.dart

class ApiConfig {
  // IP de la binôme sur le réseau Wi-Fi local
  static const String baseUrl = 'http://192.168.1.141:8080/api';

  // Headers simples — pas d'authentification pour l'instant
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };


  static String formatHeureAPI(String heure) {
    try {
      // Si déjà au bon format "HH:mm:ss"
      if (heure.contains(':') && heure.split(':').length == 3) return heure;
      // Si format "HH:mm"
      if (heure.contains(':') && heure.split(':').length == 2) return '$heure:00';
      // Si format "08h00"
      if (heure.contains('h')) {
        final parts = heure.split('h');
        final h = parts[0].padLeft(2, '0');
        final m = (parts.length > 1 && parts[1].isNotEmpty)
            ? parts[1].padLeft(2, '0')
            : '00';
        return '$h:$m:00';
      }
      return heure;
    } catch (_) {
      return heure;
    }
  }
}
