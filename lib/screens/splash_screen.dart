import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _progressController;

  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;
  late Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );

    _textController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2500),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _textSlide = Tween<Offset>(
      begin: Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    _progressAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    // Séquence d'animations
    _logoController.forward().then((_) {
      _textController.forward();
      _progressController.forward();
    });

    // Redirection après 3.5 secondes
    Future.delayed(Duration(milliseconds: 3500), () {
      Get.offAllNamed('/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF00A86B),
              Color(0xFF00855A),
              Color(0xFF005C3E),
              Color(0xFF003D29),
            ],
          ),
        ),
        child: Stack(
          children: [
            // ===== DECORATIONS GEOMETRIQUES =====
            Positioned(
              top: -60,
              right: -60,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              top: 60,
              right: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -80,
              left: -80,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
            ),
            Positioned(
              bottom: 100,
              right: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.04),
                ),
              ),
            ),

            // ===== CONTENU PRINCIPAL =====
            SafeArea(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(flex: 2),

                      // Logo animé
                      ScaleTransition(
                        scale: _logoScale,
                        child: FadeTransition(
                          opacity: _logoFade,
                          child: Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 30,
                                  offset: Offset(0, 15),
                                ),
                                BoxShadow(
                                  color: Color(0xFF00A86B).withOpacity(0.3),
                                  blurRadius: 40,
                                  offset: Offset(0, 0),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child: Image.asset(
                                  'assets/images/logo_uin.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 40),

                      // Textes animés
                      SlideTransition(
                        position: _textSlide,
                        child: FadeTransition(
                          opacity: _textFade,
                          child: Column(
                            children: [
                              Text(
                                'FST - UIN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Faculte des Sciences et Techniques',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Universite Islamique au Niger',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 20),

                              // Ligne décorative
                              Container(
                                width: 60,
                                height: 2,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),

                              SizedBox(height: 20),

                              // Sous-titre
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                ),
                                child: Text(
                                  'Digitalisation des fiches de presence',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Spacer(flex: 2),

                      // Barre de progression
                      FadeTransition(
                        opacity: _textFade,
                        child: Column(
                          children: [
                            // Barre de chargement
                            AnimatedBuilder(
                              animation: _progressAnim,
                              builder: (context, child) {
                                return Column(
                                  children: [
                                    Container(
                                      width: size.width * 0.6,
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: FractionallySizedBox(
                                        alignment: Alignment.centerLeft,
                                        widthFactor: _progressAnim.value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(2),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      'Chargement...',
                                      style: TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}