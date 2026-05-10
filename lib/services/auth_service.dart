import 'dart:convert';
import 'package:http/http.dart' as http;
import 'core/api_config.dart';
import 'core/logger_service.dart';
import '../models/user_model.dart';

class AuthService {
  Future<UserModel?> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/auth/login'),
        headers: ApiConfig.headers,
        body: jsonEncode({
          'username': username,   // ✅ correspond au backend Spring
          'motDePasse': password, // ✅ correspond au backend Spring
        }),
      ).timeout(
        // ✅ Timeout 10 secondes — évite de bloquer indéfiniment
        const Duration(seconds: 10),
        onTimeout: () {
          LoggerService.e('Login timeout — backend non disponible');
          return http.Response('timeout', 408);
        },
      );

      LoggerService.d('Login status: ${response.statusCode}');
      LoggerService.d('Login body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else if (response.statusCode == 408) {
        // Timeout — backend pas encore prêt
        LoggerService.e('Login timeout');
        return null;
      } else if (response.statusCode == 401) {
        // Mauvais identifiants
        LoggerService.e('Identifiants incorrects');
        return null;
      } else {
        LoggerService.e('Échec login: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      LoggerService.e('Erreur login : $e');
      return null;
    }
  }
}