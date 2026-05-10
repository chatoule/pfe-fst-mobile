
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Contrôleurs d'animation
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _dotsController;
  late AnimationController _badgeController;

  // Animations logo
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _logoRotate;

  // Animations texte
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  // Animation badge
  late Animation<double> _badgeFade;
  late Animation<double> _badgeScale;

  @override
  void initState() {
    super.initState();

    // ===== LOGO =====
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    _logoRotate = Tween<double>(begin: -0.1, end: 0.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    // ===== TEXTE =====
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOut),
    );

    // ===== BADGE =====
    _badgeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _badgeFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeIn),
    );
    _badgeScale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _badgeController, curve: Curves.easeOut),
    );

    // ===== DOTS =====
    _dotsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // Séquence d'animations
    _logoController.forward().then((_) {
      _textController.forward().then((_) {
        _badgeController.forward();
      });
    });

    // Redirection après 3.5 secondes
    Future.delayed(const Duration(milliseconds: 3500), () {
      if (mounted) Get.offAllNamed('/login');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _dotsController.dispose();
    _badgeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.3, -0.4),
            radius: 1.4,
            colors: [
              Color(0xFF00E085),
              Color(0xFF00A86B),
              Color(0xFF006644),
              Color(0xFF003D29),
            ],
            stops: [0.0, 0.35, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // ===== CERCLES DÉCORATIFS DE FOND =====
            Positioned(
              top: -120,
              right: -120,
              child: _buildBgCircle(350, 0.04),
            ),
            Positioned(
              bottom: -180,
              left: -100,
              child: _buildBgCircle(450, 0.04),
            ),
            Positioned(
              top: 80,
              left: -60,
              child: _buildBgCircle(220, 0.03),
            ),
            Positioned(
              bottom: 200,
              right: -40,
              child: _buildBgCircle(180, 0.03),
            ),

            // ===== CONTENU PRINCIPAL =====
            SafeArea(
              child: Column(
                children: [
                  // Spacer haut
                  const Spacer(flex: 2),

                  // ===== LOGO ANIMÉ =====
                  AnimatedBuilder(
                    animation: _logoController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFade,
                        child: Transform.rotate(
                          angle: _logoRotate.value,
                          child: ScaleTransition(
                            scale: _logoScale,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Cercles concentriques
                                _buildBgCircle(230, 0.07),
                                _buildBgCircle(180, 0.10),
                                _buildBgCircle(138, 0.15),

                                // Conteneur logo
                                Container(
                                  width: 112,
                                  height: 112,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black
                                            .withValues(alpha: 0.2),
                                        blurRadius: 30,
                                        offset: const Offset(0, 12),
                                        spreadRadius: 2,
                                      ),
                                      BoxShadow(
                                        color: const Color(0xFF00E085)
                                            .withValues(alpha: 0.3),
                                        blurRadius: 40,
                                        offset: const Offset(0, 0),
                                        spreadRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: ClipOval(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
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
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // ===== TEXTE ANIMÉ =====
                  SlideTransition(
                    position: _textSlide,
                    child: FadeTransition(
                      opacity: _textFade,
                      child: Column(
                        children: [
                          // FST - UIN
                          const Text(
                            'FST - UIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 5,
                              shadows: [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Faculté
                          Text(
                            'Faculté des Sciences et Techniques',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 4),

                          // Université
                          Text(
                            'Université Islamique au Niger',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.65),
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ===== BADGE PROJET ANIMÉ =====
                  ScaleTransition(
                    scale: _badgeScale,
                    child: FadeTransition(
                      opacity: _badgeFade,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.fingerprint,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                'Digitalisation des fiches de présence et des pointages',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                  letterSpacing: 0.3,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Spacer bas
                  const Spacer(flex: 2),

                  // ===== DOTS D'ANIMATION MODERNES =====
                  AnimatedBuilder(
                    animation: _dotsController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          // Calcul de l'animation décalée pour chaque dot
                          final progress =
                              (_dotsController.value - index * 0.25) % 1.0;
                          final isActive = progress < 0.5;
                          final size = isActive
                              ? 10.0 + (progress * 2 * 4)
                              : 10.0;
                          final opacity = isActive
                              ? 0.4 + (progress * 2 * 0.6)
                              : 0.4;

                          // Le dernier dot est rectangulaire (style moderne)
                          final isLast = index == 3;

                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: isLast ? 24 : size,
                            height: isLast ? 8 : 8,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: opacity),
                              borderRadius: BorderRadius.circular(
                                  isLast ? 4 : size / 2),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // ===== COPYRIGHT =====
                  Text(
                    '© 2026 FST - Université Islamique au Niger',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.45),
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBgCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}