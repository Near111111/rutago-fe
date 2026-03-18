import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ruta_go/screens/home_screen.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardData> _pages = [
    OnboardData(
      animation: 'assets/animations/onboard_1.json',
      title: 'Hanapin ang\nIyong Ruta',
      subtitle:
      'I-type lang ang iyong destinasyon at hahanapin namin ang pinakamadaling daan.',
      tag: '01 — Navigate',
    ),
    OnboardData(
      animation: 'assets/animations/onboard_2.json',
      title: 'Alamin ang\nSasakyan',
      subtitle:
      'MRT, LRT, bus, o jeep — aabisuhan ka namin kung alin ang sasakyan mo.',
      tag: '02 — Commute',
    ),
    OnboardData(
      animation: 'assets/animations/onboard_3.json',
      title: 'Aabisuhan\nKa Namin',
      subtitle:
      'Hindi ka maliligaw — magrereceive ka ng alerto bago mo pang maabot ang iyong hintuan.',
      tag: '03 — Alerts',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToHome();
    }
  }

  void _goToHome() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemCount: _pages.length,
            itemBuilder: (context, index) =>
                _buildPage(_pages[index], r),
          ),

          // Skip button
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: r.screenHeight * 0.07,
              right: r.spaceMD,
              child: GestureDetector(
                onTap: _goToHome,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.spaceMD,
                    vertical: r.spaceXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSM,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            bottom: r.space2XL,
            left: r.spaceMD,
            right: r.spaceMD,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Dot indicators
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.only(right: r.spaceXS * 0.75),
                      width: _currentPage == index ? r.spaceLG : r.spaceXS,
                      height: r.spaceXS * 0.75,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),

                // Next button
                GestureDetector(
                  onTap: _nextPage,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: r.spaceLG,
                      vertical: r.spaceMD,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _currentPage == _pages.length - 1
                              ? 'Magsimula'
                              : 'Susunod',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: r.fontMD,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: r.spaceXS),
                        Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: r.iconSM,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(OnboardData data, Responsive r) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: r.spaceMD),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: r.screenHeight * 0.08),

          // Tag
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.spaceSM,
              vertical: r.spaceXS * 0.75,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              data.tag,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.fontXS,
                letterSpacing: 1.0,
              ),
            ),
          ),

          SizedBox(height: r.screenHeight * 0.04),

          // Lottie
          Center(
            child: Lottie.asset(
              data.animation,
              width: r.screenWidth * 0.7,
              height: r.screenWidth * 0.7,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),

          SizedBox(height: r.screenHeight * 0.05),

          // Title
          Text(
            data.title,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: r.font3XL,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: 0.5,
            ),
          ),

          SizedBox(height: r.spaceMD),

          // Subtitle
          Text(
            data.subtitle,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: r.fontLG,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardData {
  final String animation;
  final String title;
  final String subtitle;
  final String tag;

  OnboardData({
    required this.animation,
    required this.title,
    required this.subtitle,
    required this.tag,
  });
}