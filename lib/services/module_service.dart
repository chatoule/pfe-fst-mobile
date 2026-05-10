import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_config.dart';
import 'core/logger_service.dart';

class ModuleService {
  // Récupérer tous les modules
  Future<List<dynamic>> getAllModules() async {
    try {
      final response = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/modules-cours'),
        headers: ApiConfig.headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      LoggerService.e('Erreur getAllModules: $e');
      return [];
    }
  }

  // Créer un nouveau module (utilisé par Chef de Dép)
  Future<bool> creerModule({
    required String code,
    required String intitule,
    required int volumeHoraire,
    required String semestre,
    required int departementId,
    required int enseignantId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/modules-cours'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          "code": code,
          "intitule": intitule,
          "volumeHoraire": volumeHoraire,
          "semestre": semestre,
          "departement": { "id": departementId },
          "enseignant": { "id": enseignantId }
        }),
      );

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      LoggerService.e('Erreur creerModule: $e');
      return false;
    }
  }
}
