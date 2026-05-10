import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var utilisateur = Rxn<UserModel>();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final user = await _authService.login(email, password);
      
      if (user != null) {
        utilisateur.value = user;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', user.token);
        _redirecterSelonRole(user.role);
      } else {
        errorMessage.value = 'Identifiants incorrects ou serveur indisponible';
      }
    } catch (e) {
      errorMessage.value = 'Erreur de connexion : $e';
    } finally {
      isLoading.value = false;
    }
  }

  void _redirecterSelonRole(String role) {
    switch (role) {
      case 'ENSEIGNANT':
        Get.offAllNamed('/pointage');
        break;
      case 'ETUDIANT':
        Get.offAllNamed('/presences');
        break;
      case 'CHEF_DEPARTEMENT':
        Get.offAllNamed('/chef-departement');
        break;
      case 'DOYEN':
        Get.offAllNamed('/doyen');
        break;
      case 'SUPERVISEUR':
        Get.offAllNamed('/superviseur');
        break;
      case 'SECRETAIRE':
        Get.offAllNamed('/secretaire');
        break;
      default:
        errorMessage.value = 'Role non reconnu';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    utilisateur.value = null;
    Get.offAllNamed('/login');
  }

  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}