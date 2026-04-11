import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  // On changera cette URL quand votre binôme aura le backend prêt
  static const String baseUrl = 'http://192.168.1.1:8080/api';

  // Fonction de login
  Future<UserModel?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserModel.fromJson(data);
      } else {
        return null;
      }
    } catch (e) {
      print('Erreur login : $e');
      return null;
    }
  }
}