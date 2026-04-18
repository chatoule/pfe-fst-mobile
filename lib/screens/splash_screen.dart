import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _dotsController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    _dotsController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat();

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _logoController.forward();

    Future.delayed(Duration(milliseconds: 3500), () {
      Get.offAllNamed('/finalisation-compte');
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.3),
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
            // Cercles décoratifs
            Positioned(
              top: -100,
              right: -100,
              child: _buildCircle(300, 0.05),
            ),
            Positioned(
              bottom: -150,
              left: -100,
              child: _buildCircle(400, 0.05),
            ),
            Positioned(
              top: 100,
              left: -50,
              child: _buildCircle(200, 0.04),
            ),

            SafeArea(
              child: Column(
                children: [
                  Spacer(flex: 2),

                  // Logo animé
                  ScaleTransition(
                    scale: _logoScale,
                    child: FadeTransition(
                      opacity: _logoFade,
                      child: Column(
                        children: [
                          // Cercles concentriques autour du logo
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              _buildCircle(220, 0.08),
                              _buildCircle(170, 0.12),
                              _buildCircle(130, 0.18),
                              // Logo
                              Container(
                                width: 110,
                                height: 110,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: Offset(0, 10),
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

                          SizedBox(height: 32),

                          Text('FST - UIN',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4)),
                          SizedBox(height: 6),
                          Text('Faculte des Sciences et Techniques',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 14),
                              textAlign: TextAlign.center),
                          SizedBox(height: 4),
                          Text('Universite Islamique au Niger',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 12),
                              textAlign: TextAlign.center),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.3)),
                            ),
                            child: Text(
                              'Digitalisation des fiches de presence et des pointages',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  letterSpacing: 0.5),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Spacer(flex: 2),

                  // Animation de chargement dots
                  AnimatedBuilder(
                    animation: _dotsController,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final delay = index * 0.25;
                          final animValue = (_dotsController.value - delay)
                              .clamp(0.0, 0.5);
                          final scale = 1.0 + (animValue * 1.0);
                          final opacity = 0.3 + (animValue * 1.4).clamp(0.0, 0.7);
                          return Container(
                            margin: EdgeInsets.symmetric(horizontal: 4),
                            child: Transform.scale(
                              scale: scale,
                              child: Container(
                                width: index == 3 ? 8 : 6,
                                height: index == 3 ? 16 : 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(opacity),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  SizedBox(height: 32),

                  Text('© 2026 FST - Universite Islamique au Niger',
                      style: TextStyle(color: Colors.white60, fontSize: 11)),

                  SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
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