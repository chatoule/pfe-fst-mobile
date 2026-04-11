import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var utilisateur = Rxn<UserModel>();

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    await Future.delayed(Duration(seconds: 1));

    if (email == 'enseignant@fst.ne' && password == '1234') {
      utilisateur.value = UserModel(
        id: 1, nom: 'Moussa', prenom: 'Ali',
        email: email, role: 'ENSEIGNANT', token: 'fake-token-123',
      );
      _redirecterSelonRole('ENSEIGNANT');
    } else if (email == 'etudiant@fst.ne' && password == '1234') {
      utilisateur.value = UserModel(
        id: 2, nom: 'Aminata', prenom: 'Sow',
        email: email, role: 'ETUDIANT', token: 'fake-token-456',
      );
      _redirecterSelonRole('ETUDIANT');
    } else if (email == 'doyen@fst.ne' && password == '1234') {
      utilisateur.value = UserModel(
        id: 3, nom: 'Ibrahim', prenom: 'Maiga',
        email: email, role: 'DOYEN', token: 'fake-token-789',
      );
      _redirecterSelonRole('DOYEN');
    } else if (email == 'chef@fst.ne' && password == '1234') {
      utilisateur.value = UserModel(
        id: 4, nom: 'Adamou', prenom: 'Issoufou',
        email: email, role: 'CHEF_DEPARTEMENT', token: 'fake-token-chef',
      );
      _redirecterSelonRole('CHEF_DEPARTEMENT');
    } else if (email == 'superviseur@fst.ne' && password == '1234') {
      utilisateur.value = UserModel(
        id: 5, nom: 'Zeinabou', prenom: 'Hamidou',
        email: email, role: 'SUPERVISEUR', token: 'fake-token-sup',
      );
      _redirecterSelonRole('SUPERVISEUR');
    } else if (email == 'secretaire@fst.ne' && password == '1234') {
      utilisateur.value = UserModel(
        id: 6, nom: 'Mariama', prenom: 'Sani',
        email: email, role: 'SECRETAIRE', token: 'fake-token-sec',
      );
      _redirecterSelonRole('SECRETAIRE');
    } else {
      errorMessage.value = 'Email ou mot de passe incorrect';
    }

    isLoading.value = false;
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