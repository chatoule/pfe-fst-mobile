import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  bool _obscurePassword = true;
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF00855A),
              Color(0xFF005C3E),
              Color(0xFF003D29),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ===== HEADER =====
              Expanded(
                flex: 2,
                child: FadeTransition(
                  opacity: _fadeAnim,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo avec ombre
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Image.asset(
                              'assets/images/logo_uin.png',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'FST - UIN',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 4,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Gestion des Presences',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                          letterSpacing: 1.5,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Ligne décorative
                      Container(
                        width: 50,
                        height: 2,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ===== FORMULAIRE =====
              Expanded(
                flex: 3,
                child: SlideTransition(
                  position: _slideAnim,
                  child: FadeTransition(
                    opacity: _fadeAnim,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 25,
                            offset: Offset(0, -8),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(32, 36, 32, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Titre
                            Text(
                              'Connexion',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF003D29),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Connectez-vous a votre compte',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 32),

                            // Champ Email
                            Text('Email',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF003D29),
                                  fontSize: 14,
                                )),
                            SizedBox(height: 8),
                            TextField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                hintText: 'exemple@fst.ne',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(Icons.email_outlined,
                                    color: Color(0xFF00855A)),
                                filled: true,
                                fillColor: Color(0xFFF5FAF7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: Color(0xFF00855A), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                              ),
                            ),
                            SizedBox(height: 20),

                            // Champ Mot de passe
                            Text('Mot de passe',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF003D29),
                                  fontSize: 14,
                                )),
                            SizedBox(height: 8),
                            TextField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: '••••••••',
                                hintStyle: TextStyle(color: Colors.grey[400]),
                                prefixIcon: Icon(Icons.lock_outline,
                                    color: Color(0xFF00855A)),
                                // 👁️ Bouton voir/cacher mot de passe
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey[400],
                                  ),
                                  onPressed: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                ),
                                filled: true,
                                fillColor: Color(0xFFF5FAF7),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: Color(0xFF00855A), width: 2),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(14),
                                  borderSide: BorderSide(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                              ),
                            ),
                            SizedBox(height: 12),

                            // Message d'erreur
                            Obx(() {
                              if (_authController
                                  .errorMessage.value.isNotEmpty) {
                                return Container(
                                  padding: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 12),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(10),
                                    border:
                                    Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.red, size: 18),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          _authController.errorMessage.value,
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 13),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }
                              return SizedBox.shrink();
                            }),

                            SizedBox(height: 24),

                            // Bouton Se connecter
                            Obx(() {
                              return SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: ElevatedButton(
                                  onPressed: _authController.isLoading.value
                                      ? null
                                      : () {
                                    _authController.login(
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF00855A),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    elevation: 4,
                                    shadowColor:
                                    Color(0xFF00855A).withOpacity(0.5),
                                  ),
                                  child: _authController.isLoading.value
                                      ? Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      ),
                                      SizedBox(width: 12),
                                      Text('Connexion...',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16)),
                                    ],
                                  )
                                      : Text(
                                    'Se connecter',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              );
                            }),

                            SizedBox(height: 24),

                            // Footer
                            Center(
                              child: Text(
                                'Universite Islamique au Niger © 2026',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}