import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cours_model.dart';

class PointageService {
  static const String baseUrl = 'http://192.168.1.1:8080/api';

  Future<List<CoursModel>> getCours(int enseignantId, String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cours/enseignant/$enseignantId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CoursModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur getCours : $e');
      return [];
    }
  }

  Future<bool> pointerCours(int coursId, String token) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/cours/$coursId/pointer'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'statut': 'TERMINE'}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('Erreur pointerCours : $e');
      return false;
    }
  }

  Future<List<CoursModel>> getTousCours(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/cours'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((e) => CoursModel.fromJson(e)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Erreur getTousCours : $e');
      return [];
    }
  }
}