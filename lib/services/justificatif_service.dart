

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_config.dart';
import 'core/logger_service.dart';

class JustificatifService {

  // ===== SOUMETTRE UN JUSTIFICATIF =====
  // POST /api/justificatifs
  Future<bool> soumettreJustificatif({
    required int etudiantId,
    required int seanceId,
    required String motif,
    String? fichierUrl,
  }) async {
    try {
      final body = jsonEncode({
        'etudiantId': etudiantId,
        'seanceId': seanceId,
        'motif': motif,
        'statut': 'EN_ATTENTE',
        if (fichierUrl != null) 'fichierUrl': fichierUrl,
      });

      LoggerService.d('soumettreJustificatif body: $body');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/justificatifs'),
        headers: ApiConfig.headers,
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('soumettreJustificatif timeout');
          return http.Response('timeout', 408);
        },
      );

      LoggerService.d('soumettreJustificatif status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      LoggerService.e('Erreur soumettreJustificatif : $e');
      return false;
    }
  }

  // ===== RÉCUPÉRER TOUS LES JUSTIFICATIFS EN ATTENTE =====
  // GET /api/justificatifs/en-attente
  Future<List<dynamic>> getJustificatifsEnAttente() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/justificatifs/en-attente'),
        headers: ApiConfig.headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('getJustificatifsEnAttente timeout');
          return http.Response('[]', 408);
        },
      );

      LoggerService.d('getJustificatifsEnAttente: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getJustificatifsEnAttente : $e');
      return [];
    }
  }

  // ===== RÉCUPÉRER LES JUSTIFICATIFS D'UN ÉTUDIANT =====
  // GET /api/justificatifs/etudiant/{id}
  Future<List<dynamic>> getJustificatifsEtudiant(int etudiantId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/justificatifs/etudiant/$etudiantId'),
        headers: ApiConfig.headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('getJustificatifsEtudiant timeout');
          return http.Response('[]', 408);
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getJustificatifsEtudiant : $e');
      return [];
    }
  }
}
