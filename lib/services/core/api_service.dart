import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';
import '../../models/user_model.dart';
import '../../models/presence_model.dart';
import 'logger_service.dart';

class ApiService {
  // --- AUTHENTIFICATION ---
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: ApiConfig.headers,
        body: jsonEncode({'username': username, 'motDePasse': password}),
      );
      if (response.statusCode == 200) return UserModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      LoggerService.e('Erreur Login', e);
    }
    return null;
  }

  // --- ETUDIANT & PRESENCES ---
  Future<Map<String, dynamic>?> getProfilEtudiant(int id) async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/etudiants/$id'), headers: ApiConfig.headers);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { LoggerService.e('Erreur Profil', e); }
    return null;
  }

  Future<List<PresenceModel>> getPresencesEtudiant(int id) async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/presences/etudiant/$id'), headers: ApiConfig.headers);
      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => PresenceModel.fromJson(e)).toList();
      }
    } catch (e) { LoggerService.e('Erreur Presences', e); }
    return [];
  }

  // --- SEANCES & POINTAGES ---
  Future<List<dynamic>> getSeancesEnseignant(int id) async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/seances/enseignant/$id'), headers: ApiConfig.headers);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { LoggerService.e('Erreur Seances', e); }
    return [];
  }

  Future<bool> creerPointage(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/pointages'),
        headers: ApiConfig.headers,
        body: jsonEncode(data),
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      LoggerService.e('Erreur Pointage', e);
      return false;
    }
  }

  // --- MODULES ---
  Future<List<dynamic>> getAllModules() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/modules-cours'), headers: ApiConfig.headers);
      if (response.statusCode == 200) return jsonDecode(response.body);
    } catch (e) { LoggerService.e('Erreur Modules', e); }
    return [];
  }
}
