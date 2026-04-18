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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... (garder le container d'en-tête)
            Container(
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_uin.png', height: 80),
                  const SizedBox(height: 16),
                  const Text(
                    'Finalisation de compte',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() {
                      final user = _authController.utilisateur.value;
                      return Text(
                        'Bienvenue ${user?.prenom ?? ""} ${user?.nom ?? ""}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29),
                        ),
                      );
                    }),
                    const SizedBox(height: 8),
                    const Text(
                      'Veuillez définir votre mot de passe pour activer votre compte institutionnel.',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Nouveau mot de passe',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => (v == null || v.length < 6) ? '6 caractères minimum' : null,
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirm,
                      enabled: !_isLoading,
                      decoration: InputDecoration(
                        labelText: 'Confirmer le mot de passe',
                        prefixIcon: const Icon(Icons.lock_reset),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (v) => v != _passwordController.text ? 'Les mots de passe ne correspondent pas' : null,
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            
                            // Simulation d'appel API
                            await Future.delayed(const Duration(seconds: 2));
                            
                            Get.offAllNamed('/login');
                            final user = _authController.utilisateur.value;
                            Get.snackbar(
                              'Compte activé',
                              'Félicitations ${user?.prenom ?? ""} ! Votre compte est prêt.',
                              backgroundColor: const Color(0xFF00855A),
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                              icon: const Icon(Icons.check_circle, color: Colors.white),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00855A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isLoading 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'ACTIVER MON COMPTE',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
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
}
