import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'core/api_config.dart';
import 'core/logger_service.dart';

class PointageService {

  // ===== RÉCUPÉRER LES POINTAGES EN ATTENTE =====
  Future<List<dynamic>> getPointagesEnAttente() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pointages/en-attente'),
        headers: ApiConfig.headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('getPointagesEnAttente timeout');
          return http.Response('[]', 408);
        },
      );
      LoggerService.d('getPointagesEnAttente: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getPointagesEnAttente : $e');
      return [];
    }
  }

  // ===== CRÉER UN POINTAGE =====
  Future<bool> creerPointage({
    required String date,
    required int seanceId,
    required int enseignantId,
    required String heureDebut,
    required String heureFin,
    String? contenu,
    String statut = "EN_ATTENTE",
  }) async {
    try {
      // ✅ Conversion automatique du format heure "08h00" → "08:00:00"
      final heureDebutFormatted = ApiConfig.formatHeureAPI(heureDebut);
      final heureFinFormatted = ApiConfig.formatHeureAPI(heureFin);

      final body = jsonEncode({
        "date": date,
        "seanceId": seanceId,
        "enseignantId": enseignantId,
        "heureDebut": heureDebutFormatted,
        "heureFin": heureFinFormatted,
        "statut": statut,
      });

      LoggerService.d('creerPointage body: $body');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/pointages'),
        headers: ApiConfig.headers,
        body: body,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('creerPointage timeout');
          return http.Response('timeout', 408);
        },
      );

      LoggerService.d('creerPointage status: ${response.statusCode}');
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      LoggerService.e('Erreur creerPointage : $e');
      return false;
    }
  }

  // ===== METTRE À JOUR LE STATUT D'UN POINTAGE =====
  // ⚠️ Endpoint PUT /pointages/{id}/statut — à confirmer avec Dayyanatou
  Future<bool> updateStatut(int pointageId, String statut,
      {String? motif}) async {
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/pointages/$pointageId/statut'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          "statut": statut,
          if (motif != null) "motif": motif,
        }),
      ).timeout(
        // ✅ Timeout 10 secondes pour éviter d'attendre indéfiniment
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('updateStatut timeout — endpoint non disponible');
          return http.Response('timeout', 408);
        },
      );

      LoggerService.d('updateStatut [$pointageId → $statut]: ${response.statusCode}');

      if (response.statusCode == 200) {
        return true;
      }

      // ✅ Afficher un message si l'endpoint n'est pas encore disponible
      if (response.statusCode == 404 || response.statusCode == 408) {
        Get.snackbar(
          'Fonctionnalité en attente',
          'La validation sera disponible dès que le backend est prêt.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
          margin: const EdgeInsets.all(16),
        );
      }

      return false;
    } catch (e) {
      LoggerService.e('Erreur updateStatut : $e');
      return false;
    }
  }

  // ===== RÉCUPÉRER TOUS LES POINTAGES =====
  Future<List<dynamic>> getAllPointages() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pointages'),
        headers: ApiConfig.headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('getAllPointages timeout');
          return http.Response('[]', 408);
        },
      );
      LoggerService.d('getAllPointages: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getAllPointages : $e');
      return [];
    }
  }

  // ===== RÉCUPÉRER LES POINTAGES D'UN ENSEIGNANT =====
  Future<List<dynamic>> getPointagesEnseignant(int enseignantId) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/pointages/enseignant/$enseignantId'),
        headers: ApiConfig.headers,
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('getPointagesEnseignant timeout');
          return http.Response('[]', 408);
        },
      );
      LoggerService.d('getPointagesEnseignant: ${response.statusCode}');
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      LoggerService.e('Erreur getPointagesEnseignant : $e');
      return [];
    }
  }
}