// lib/services/presence_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_config.dart';
import 'core/logger_service.dart';

class PresenceService {
  // Récupérer les présences d'un étudiant
  Future<List<dynamic>> getPresencesEtudiant(int etudiantId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/presences/etudiant/$etudiantId'),
        headers: ApiConfig.headers,
      );
      LoggerService.d('getPresencesEtudiant: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getPresencesEtudiant: $e');
      return [];
    }
  }

  // ✅ CORRIGÉ : body conforme à la doc API de la binôme
  // POST /presences
  // { "datePresence": "2026-04-24", "statut": "ABSENT", "remarque": "...",
  //   "etudiantId": 13, "seanceId": 9 }
  Future<bool> marquerPresence({
    required String datePresence,
    required bool estPresent,  // true → "PRESENT", false → "ABSENT"
    required int etudiantId,
    required int seanceId,
    String remarque = '',
  }) async {
    try {
      final body = jsonEncode({
        "datePresence": datePresence,
        "statut": estPresent ? "PRESENT" : "ABSENT",  // ✅ valeurs exactes de l'API
        "remarque": remarque,
        "etudiantId": etudiantId,
        "seanceId": seanceId,
      });

      LoggerService.d('marquerPresence body: $body');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/presences'),
        headers: ApiConfig.headers,
        body: body,
      );

      LoggerService.d('marquerPresence status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      LoggerService.e('Erreur marquerPresence: $e');
      return false;
    }
  }
}
