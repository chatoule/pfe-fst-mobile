import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );

    _slideAnim = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ✅ AUTH BIOMÉTRIQUE CORRIGÉ
  Future<void> _authenticateWithBiometrics() async {
    try {
      final List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();

      if (availableBiometrics.isEmpty) {
        Get.snackbar(
          'Info',
          'Aucune biométrie disponible',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
        return;
      }

      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authentifiez-vous pour vous connecter',
        biometricOnly: true,
      );

      if (authenticated) {
        _authController.login('enseignant@fst.ne', '1234');
      }
    } catch (e) {
      Get.snackbar(
        'Erreur',
        'Authentification biométrique échouée',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.5,
            colors: [
              Color(0xFF00C97A),
              Color(0xFF00855A),
              Color(0xFF005C3E),
              Color(0xFF003D29),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -80, right: -80, child: _buildCircle(250, 0.06)),
            Positioned(top: 50, right: -30, child: _buildCircle(150, 0.05)),
            Positioned(bottom: -100, left: -80, child: _buildCircle(300, 0.05)),

            SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    SizedBox(height: 30),

                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildCircle(200, 0.08),
                          _buildCircle(155, 0.12),
                          _buildCircle(115, 0.18),
                          Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 20,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/logo_uin.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 16),

                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          Text(
                            'FST - UIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gestion des Presences et des pointages',
                            style:
                            TextStyle(color: Colors.white70, fontSize: 13),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24),

                    SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          padding: EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                                color: Colors.white.withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Connexion',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold)),

                              SizedBox(height: 20),

                              _buildTextField(
                                controller: _emailController,
                                hint: 'exemple@fst.ne',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),

                              SizedBox(height: 14),

                              _buildTextField(
                                controller: _passwordController,
                                hint: '••••••••',
                                icon: Icons.lock_outline,
                                obscure: _obscurePassword,
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white60,
                                  ),
                                  onPressed: () => setState(() =>
                                  _obscurePassword = !_obscurePassword),
                                ),
                              ),

                              SizedBox(height: 20),

                              Obx(() {
                                return ElevatedButton(
                                  onPressed: _authController.isLoading.value
                                      ? null
                                      : () {
                                    _authController.login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(double.infinity, 50),
                                    backgroundColor: Colors.white,
                                  ),
                                  child: _authController.isLoading.value
                                      ? CircularProgressIndicator(color: Color(0xFF00855A))
                                      : Text(
                                          'SE CONNECTER',
                                          style: TextStyle(
                                            color: Color(0xFF00855A),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                );
                              }),

                              SizedBox(height: 20),

                              Center(
                                child: GestureDetector(
                                  onTap: _authenticateWithBiometrics,
                                  child: Icon(Icons.fingerprint,
                                      size: 40, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        prefixIcon: Icon(icon, color: Colors.white),
        suffixIcon: suffixIcon,
      ),
    );
  }

  Widget _buildCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withOpacity(opacity),
      ),
    );
  }
}