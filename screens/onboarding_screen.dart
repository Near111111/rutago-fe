import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:ruta_go/screens/home_screen.dart';

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
      subtitle: 'I-type lang ang iyong destinasyon\nat hahanapin namin ang pinakamadaling daan.',
      tag: '01 — Navigate',
    ),
    OnboardData(
      animation: 'assets/animations/onboard_2.json',
      title: 'Alamin ang\nSasakyan',
      subtitle: 'MRT, LRT, bus, o jeep —\naabisuhan ka namin kung alin ang sasakyan mo.',
      tag: '02 — Commute',
    ),
    OnboardData(
      animation: 'assets/animations/onboard_3.json',
      title: 'Aabisuhan\nKa Namin',
      subtitle: 'Hindi ka maliligaw —\nmagrereceive ka ng alerto bago mo pang maabot ang iyong hintuan.',
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
        pageBuilder: (context, animation, secondaryAnimation) =>
        const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
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
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [

          // Page View
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemCount: _pages.length,
            itemBuilder: (context, index) {
              return _buildPage(_pages[index], size);
            },
          ),

          // Skip button — top right
          if (_currentPage < _pages.length - 1)
            Positioned(
              top: 56,
              right: 24,
              child: GestureDetector(
                onTap: _goToHome,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: const Color(0xFF2A2A2A),
                    ),
                  ),
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: Color(0xFF888888),
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),

          // Bottom controls
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                // Dot indicators
                Row(
                  children: List.generate(
                    _pages.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.only(right: 6),
                      width: _currentPage == index ? 24 : 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : const Color(0xFF333333),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),

                // Next / Get Started button
                GestureDetector(
                  onTap: _nextPage,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
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
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.black,
                          size: 16,
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

  Widget _buildPage(OnboardData data, Size size) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: size.height * 0.08),

          // Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFF2A2A2A)),
            ),
            child: Text(
              data.tag,
              style: const TextStyle(
                color: Color(0xFF888888),
                fontSize: 11,
                letterSpacing: 1.0,
              ),
            ),
          ),

          SizedBox(height: size.height * 0.04),

          // Lottie animation — centered
          Center(
            child: Lottie.asset(
              data.animation,
              width: size.width * 0.7,
              height: size.width * 0.7,
              fit: BoxFit.contain,
              repeat: true,
            ),
          ),

          SizedBox(height: size.height * 0.05),

          // Title
          Text(
            data.title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          Text(
            data.subtitle,
            style: const TextStyle(
              color: Color(0xFF888888),
              fontSize: 15,
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