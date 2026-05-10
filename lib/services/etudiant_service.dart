// lib/services/etudiant_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_config.dart';
import 'core/logger_service.dart'; // ✅ CORRIGÉ : LoggerService au lieu de print()

class EtudiantService {
  // Récupérer le profil complet d'un étudiant par son ID
  // GET /api/etudiants/{id}
  Future<Map<String, dynamic>?> getProfilEtudiant(int etudiantId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/etudiants/$etudiantId'),
        headers: ApiConfig.headers,
      );
      LoggerService.d('getProfilEtudiant: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      LoggerService.e('Erreur profil étudiant: ${response.statusCode}');
      return null;
    } catch (e) {
      LoggerService.e('Erreur réseau profil étudiant: $e');
      return null;
    }
  }

  // Récupérer tous les étudiants
  // GET /api/etudiants
  Future<List<dynamic>> getAllEtudiants() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/etudiants'),
        headers: ApiConfig.headers,
      );
      LoggerService.d('getAllEtudiants: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getAllEtudiants: $e');
      return [];
    }
  }
}
