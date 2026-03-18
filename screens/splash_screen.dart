import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ruta_go/screens/home_screen.dart';
import 'package:ruta_go/screens/onboarding_screen.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _slideController.forward();
    });

    // Always go to onboarding — temporary para ma-check design
    Future.delayed(const Duration(seconds: 4), () {
      _goToOnboarding();
    });
  }

  void _goToOnboarding() {
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const OnboardingScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 800),
      ),
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // Top glow
          Positioned(
            top: -100,
            left: r.screenWidth / 2 - 150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Bottom glow
          Positioned(
            bottom: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.orange.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main content
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                SizedBox(height: r.screenHeight * 0.12),

                // Lottie animation
                Lottie.asset(
                  'assets/animations/splash_animation.json',
                  width: r.screenWidth * 0.75,
                  height: r.screenWidth * 0.75,
                  fit: BoxFit.contain,
                  repeat: true,
                ),

                SizedBox(height: r.screenHeight * 0.04),

                // Text with slide animation
                SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [

                      // App name
                      Text(
                        'RutaGo',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: r.font4XL,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 2.0,
                        ),
                      ),

                      SizedBox(height: r.spaceXS),

                      // Tagline
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: r.screenWidth * 0.015,
                            height: r.screenWidth * 0.015,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: r.spaceXS),
                          Text(
                            'Your route, we know it.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: r.fontMD,
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(width: r.spaceXS),
                          Container(
                            width: r.screenWidth * 0.015,
                            height: r.screenWidth * 0.015,
                            decoration: const BoxDecoration(
                              color: AppColors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                // Progress bar + loading text
                SlideTransition(
                  position: _slideAnimation,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: r.space2XL),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: const LinearProgressIndicator(
                            value: null,
                            backgroundColor: Color(0xFF1E1E1E),
                            color: Colors.white,
                            minHeight: 2,
                          ),
                        ),
                        SizedBox(height: r.spaceMD),
                        Text(
                          'Initializing map...',
                          style: TextStyle(
                            color: AppColors.textDisabled,
                            fontSize: r.fontSM,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: r.spaceLG),

                // Version
                Text(
                  'v1.0.0',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.15),
                    fontSize: r.fontXS,
                  ),
                ),

                SizedBox(height: r.spaceMD),
              ],
            ),
          ),
        ],
      ),
    );
  }
}