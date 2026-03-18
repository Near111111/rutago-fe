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
      title: 'Find Your\nRoute',
      subtitle:
      'Type your destination and we will find the easiest way to get there.',
      tag: '01 — Navigate',
    ),
    OnboardData(
      animation: 'assets/animations/onboard_2.json',
      title: 'Know Your\nTransport',
      subtitle:
      'MRT, LRT, bus, or jeep — we will tell you exactly which ride to take.',
      tag: '02 — Commute',
    ),
    OnboardData(
      animation: 'assets/animations/onboard_3.json',
      title: 'We Will\nAlert You',
      subtitle:
      'Never get lost — receive alerts before you reach your stop.',
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
      body: SafeArea(
        child: Column(
          children: [

            // ✅ Fixed Header — Skip at Tag pantay na
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: r.spaceMD,
                vertical: r.spaceSM,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // Tag pill
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Container(
                      key: ValueKey(_currentPage),
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
                        _pages[_currentPage].tag,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.fontXS,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                  ),

                  // Skip button
                  if (_currentPage < _pages.length - 1)
                    GestureDetector(
                      onTap: _goToHome,
                      child: Container(
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
                          'Skip',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: r.fontXS,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox.shrink(),
                ],
              ),
            ),

            // Lottie animation
            Expanded(
              flex: 5,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) =>
                    setState(() => _currentPage = index),
                itemCount: _pages.length,
                itemBuilder: (context, index) =>
                    _buildAnimationSection(_pages[index], r),
              ),
            ),

            // ✅ Fixed Bottom — Text + Dots + Button hindi na nagtatakipan
            Container(
              padding: EdgeInsets.fromLTRB(
                r.spaceMD,
                r.spaceMD,
                r.spaceMD,
                r.spaceLG,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  // Title
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _pages[_currentPage].title,
                      key: ValueKey('title_$_currentPage'),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.font3XL,
                        fontWeight: FontWeight.w800,
                        height: 1.2,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceSM),

                  // Subtitle
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      _pages[_currentPage].subtitle,
                      key: ValueKey('subtitle_$_currentPage'),
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: r.fontMD,
                        height: 1.6,
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceLG),

                  // ✅ Dots + Button sa same row — hindi na nagtatakipan
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [

                      // Dot indicators
                      Row(
                        children: List.generate(
                          _pages.length,
                              (index) => AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: EdgeInsets.only(right: r.spaceXS * 0.75),
                            width: _currentPage == index
                                ? r.spaceLG
                                : r.spaceXS,
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

                      // Next / Magsimula button
                      GestureDetector(
                        onTap: _nextPage,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          padding: EdgeInsets.symmetric(
                            horizontal: r.spaceLG,
                            vertical: r.spaceMD,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? 'Get Started'
                                    : 'Next',
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationSection(OnboardData data, Responsive r) {
    return Center(
      child: Lottie.asset(
        data.animation,
        width: r.screenWidth * 0.65,
        height: r.screenWidth * 0.65,
        fit: BoxFit.contain,
        repeat: true,
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