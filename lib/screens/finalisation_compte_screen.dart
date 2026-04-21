import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class FinalisationCompteScreen extends StatefulWidget {
  const FinalisationCompteScreen({super.key});

  @override
  State<FinalisationCompteScreen> createState() => _FinalisationCompteScreenState();
}

class _FinalisationCompteScreenState extends State<FinalisationCompteScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  // Critères de validation
  bool get _hasSixChars => _passwordController.text.length >= 6;
  bool get _hasNumber => _passwordController.text.contains(RegExp(r'[0-9]'));
  bool get _hasUpper => _passwordController.text.contains(RegExp(r'[A-Z]'));

  void _onPasswordChanged(String value) {
    setState(() {}); // Rafraîchir les indicateurs de force
  }

  Future<void> _finaliser() async {
    if (!_formKey.currentState!.validate()) return;
    if (!(_hasSixChars && _hasNumber)) {
      Get.snackbar(
        'Sécurité faible',
        'Veuillez respecter les critères de sécurité du mot de passe.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Ici on appellerait une méthode dans AuthController pour mettre à jour le MDP
      // simulation de délai réseau
      await Future.delayed(const Duration(seconds: 2));
      
      final user = _authController.utilisateur.value;
      
      Get.offAllNamed('/login');
      
      Get.snackbar(
        'Compte Activé !',
        'Félicitations ${user?.prenom}, votre mot de passe a été configuré. Connectez-vous maintenant.',
        backgroundColor: const Color(0xFF00855A),
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        icon: const Icon(Icons.verified_user, color: Colors.white),
      );
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de finaliser le compte. Réessayez.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.utilisateur.value;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header stylisé
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 60, bottom: 40, left: 24, right: 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.shield_outlined, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Sécurisez votre compte',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Dernière étape pour accéder à l\'espace FST',
                    style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Carte d'identité utilisateur
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF00855A).withOpacity(0.1),
                            child: Text(
                                (user?.prenom != null && user!.prenom.isNotEmpty) 
                                    ? user.prenom[0].toUpperCase() 
                                    : 'U', 
                                style: const TextStyle(color: Color(0xFF00855A), fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${user?.prenom ?? ""} ${user?.nom ?? ""}'.trim().isEmpty 
                                    ? "Utilisateur" 
                                    : '${user?.prenom ?? ""} ${user?.nom ?? ""}', 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                Text(user?.email ?? 'Email non renseigné',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    const Text('NOUVEAU MOT DE PASSE', 
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      onChanged: _onPasswordChanged,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Entrez un mot de passe robuste',
                        prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF00855A)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Champ requis' : null,
                    ),

                    const SizedBox(height: 16),

                    // Indicateurs de force
                    Wrap(
                      spacing: 12,
                      children: [
                        _buildRequirementItem('6+ caractères', _hasSixChars),
                        _buildRequirementItem('Un chiffre', _hasNumber),
                        _buildRequirementItem('Une majuscule', _hasUpper),
                      ],
                    ),

                    const SizedBox(height: 24),

                    const Text('CONFIRMATION', 
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.2)),
                    const SizedBox(height: 12),
                    
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Confirmez le mot de passe',
                        prefixIcon: const Icon(Icons.lock_reset, color: Color(0xFF00855A)),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                      ),
                      validator: (v) => v != _passwordController.text ? 'Les mots de passe ne correspondent pas' : null,
                    ),

                    const SizedBox(height: 48),

                    // Bouton d'action
                    Container(
                      width: double.infinity,
                      height: 58,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF00855A).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _finaliser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00855A),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('ACTIVER MON COMPTE', 
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                                SizedBox(width: 8),
                                Icon(Icons.arrow_forward_rounded),
                              ],
                            ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    Center(
                      child: TextButton(
                        onPressed: () => Get.back(),
                        child: Text('Annuler et revenir', style: TextStyle(color: Colors.grey[600])),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequirementItem(String label, bool isMet) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check_circle : Icons.circle_outlined,
          size: 14,
          color: isMet ? Colors.green : Colors.grey[400],
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: isMet ? Colors.green[700] : Colors.grey[600],
            fontWeight: isMet ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
