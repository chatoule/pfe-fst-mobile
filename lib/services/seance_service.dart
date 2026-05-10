// lib/services/seance_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_config.dart';
import 'core/logger_service.dart';

class SeanceService {
  // Récupérer les séances pour un enseignant
  Future<List<dynamic>> getSeancesEnseignant(int enseignantId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/seances/enseignant/$enseignantId'),
        headers: ApiConfig.headers,
      );
      LoggerService.d('getSeancesEnseignant: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      LoggerService.e('Erreur getSeancesEnseignant: ${response.statusCode}');
      return [];
    } catch (e) {
      LoggerService.e('Erreur réseau seances enseignant: $e');
      return [];
    }
  }

  // Séances d'aujourd'hui pour un département
  Future<List<dynamic>> getSeancesAujourdhui(int departementId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}/seances/aujourd-hui/departement/$departementId'),
        headers: ApiConfig.headers,
      );
      LoggerService.d('getSeancesAujourdhui: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      LoggerService.e('Erreur getSeancesAujourdhui: ${response.statusCode}');
      return [];
    } catch (e) {
      LoggerService.e('Erreur réseau seances aujourdhui: $e');
      return [];
    }
  }

  // Séances de la semaine pour un département
  Future<List<dynamic>> getSeancesSemaine(int departementId) async {
    try {
      final response = await http.get(
        Uri.parse(
            '${ApiConfig.baseUrl}/seances/semaine/departement/$departementId'),
        headers: ApiConfig.headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur réseau seances semaine: $e');
      return [];
    }
  }

  // Créer une nouvelle séance (rattrapage ou anticipation)
  // ✅ CORRIGÉ : format heures "08:00:00" au lieu de "08h00"
  Future<bool> creerSeance({
    required String dateSeance,
    required String heureDebut,
    required String heureFin,
    required String typeSeance,
    required int enseignantId,
    required int moduleId,
    required int salleId,
  }) async {
    try {
      // Conversion automatique du format heure
      final heureDebutFormatted = ApiConfig.formatHeureAPI(heureDebut);
      final heureFinFormatted = ApiConfig.formatHeureAPI(heureFin);

      final body = jsonEncode({
        "dateSeance": dateSeance,
        "heureDebut": heureDebutFormatted,   // ✅ "08:00:00"
        "heureFin": heureFinFormatted,       // ✅ "10:00:00"
        "typeSeance": typeSeance,            // "NORMALE", "RATTRAPAGE", "ANTICIPATION"
        "enseignantId": enseignantId,
        "moduleId": moduleId,
        "salleId": salleId,
      });

      LoggerService.d('creerSeance body: $body');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/seances'),
        headers: ApiConfig.headers,
        body: body,
      );

      LoggerService.d('creerSeance status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      LoggerService.e('Erreur creerSeance: $e');
      return false;
    }
  }
}
