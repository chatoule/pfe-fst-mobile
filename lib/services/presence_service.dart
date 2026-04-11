import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/presence_model.dart';

class PresenceService {
  static const String baseUrl = 'http://192.168.1.1:8080/api';

  // Récupérer la liste des présences d'un cours
  Future<List<PresenceModel>> getPresences(int coursId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/presences/cours/$coursId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => PresenceModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur getPresences : $e');
      return [];
    }
  }

  // Marquer la présence d'un étudiant
  Future<bool> marquerPresence(
      int etudiantId, int coursId, bool estPresent, String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/presences'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'etudiantId': etudiantId,
          'coursId': coursId,
          'estPresent': estPresent,
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Erreur marquerPresence : $e');
      return false;
    }
  }
}