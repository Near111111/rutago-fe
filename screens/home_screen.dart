import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';
import 'package:ruta_go/screens/search_screen.dart';
import 'package:ruta_go/screens/saved_screen.dart';
import 'package:ruta_go/screens/settings_screen.dart';
import 'package:ruta_go/screens/login_screen.dart';
import 'package:ruta_go/screens/register_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoggedIn = false;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      const _HomeTab(),
      const Center(
          child: Text('Search',
              style: TextStyle(color: Colors.white))),
      const SavedScreen(),
      const SettingsScreen(),
    ];
  }

  void _checkAuthForSaved() {
    if (_isLoggedIn) {
      setState(() => _currentIndex = 2);
    } else {
      _showLoginPrompt();
    }
  }

  void _showLoginPrompt() {
    final r = Responsive(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.fromLTRB(
          r.spaceMD,
          r.spaceMD,
          r.spaceMD,
          r.spaceLG,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(r.radiusXL),
          ),
          border: const Border(
            top: BorderSide(color: AppColors.borderAlt),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            // Handle
            Center(
              child: Container(
                width: r.screenWidth * 0.1,
                height: 4,
                margin: EdgeInsets.only(bottom: r.spaceLG),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),

            // Icon
            Container(
              padding: EdgeInsets.all(r.spaceLG),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                Icons.bookmark_outline,
                color: AppColors.textSecondary,
                size: r.iconXL,
              ),
            ),

            SizedBox(height: r.spaceLG),

            // Title
            Text(
              'Sign in to Save Places',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: r.fontXL,
                fontWeight: FontWeight.w800,
              ),
            ),

            SizedBox(height: r.spaceXS),

            // Subtitle
            Text(
              'Create an account or sign in to save\nyour favorite destinations.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.fontMD,
                height: 1.5,
              ),
            ),

            SizedBox(height: r.spaceLG),

            // Sign In button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                    const LoginScreen(),
                    transitionsBuilder:
                        (_, animation, __, child) =>
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                    transitionDuration:
                    const Duration(milliseconds: 400),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                EdgeInsets.symmetric(vertical: r.spaceMD),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.circular(r.radiusLG),
                ),
                child: Text(
                  'Sign In',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: r.fontMD,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),

            SizedBox(height: r.spaceSM),

            // Register button
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (_, __, ___) =>
                    const RegisterScreen(),
                    transitionsBuilder:
                        (_, animation, __, child) =>
                        SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 1),
                            end: Offset.zero,
                          ).animate(CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          )),
                          child: child,
                        ),
                    transitionDuration:
                    const Duration(milliseconds: 400),
                  ),
                );
              },
              child: Container(
                width: double.infinity,
                padding:
                EdgeInsets.symmetric(vertical: r.spaceMD),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius:
                  BorderRadius.circular(r.radiusLG),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.fontMD,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(height: r.spaceSM),

            // Maybe later
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Text(
                'Maybe later',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: r.fontSM,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.background,
          border: Border(
            top: BorderSide(color: AppColors.borderAlt, width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) =>
                  const SearchScreen(),
                  transitionsBuilder:
                      (_, animation, __, child) =>
                      FadeTransition(
                        opacity: animation,
                        child: child,
                      ),
                  transitionDuration:
                  const Duration(milliseconds: 300),
                ),
              );
            } else if (index == 2) {
              _checkAuthForSaved();
            } else {
              setState(() => _currentIndex = index);
            }
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.orange,
          unselectedItemColor: const Color(0xFF555555),
          selectedLabelStyle: TextStyle(
            fontSize: r.fontXS,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: TextStyle(fontSize: r.fontXS),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark_outline),
              activeIcon: Icon(Icons.bookmark),
              label: 'Saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined),
              activeIcon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Home Tab ──────────────────────────────────────────

class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final MapController _mapController = MapController();
  LatLng _currentPosition = const LatLng(14.5995, 120.9842);
  bool _isLoadingLocation = true;

  final List<Map<String, String>> _recentSearches = const [
    {'name': 'SM Mall of Asia', 'address': 'Bay City, Pasay'},
    {'name': 'Makati', 'address': 'Ayala Avenue, Makati'},
    {'name': 'BGC High Street', 'address': 'Bonifacio Global City'},
  ];

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _isLoadingLocation = false);
        return;
      }

      LocationPermission permission =
      await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoadingLocation = false);
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (mounted) {
        setState(() {
          _currentPosition =
              LatLng(position.latitude, position.longitude);
          _isLoadingLocation = false;
        });
        _mapController.move(_currentPosition, 15);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingLocation = false);
      }
    }
  }

  void _recenterMap() {
    _mapController.move(_currentPosition, 15);
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Stack(
      children: [

        // Flutter Map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _currentPosition,
            initialZoom: 14,
            minZoom: 5,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
              subdomains: const ['a', 'b', 'c', 'd'],
              userAgentPackageName: 'com.example.ruta_go',
              retinaMode: true,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition,
                  width: r.screenWidth * 0.15,
                  height: r.screenWidth * 0.15,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: r.screenWidth * 0.12,
                        height: r.screenWidth * 0.12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue.withOpacity(0.15),
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                      ),
                      Container(
                        width: r.screenWidth * 0.04,
                        height: r.screenWidth * 0.04,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blue,
                          border: Border.all(
                            color: Colors.white,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.4),
                              blurRadius: 8,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Loading location indicator
        if (_isLoadingLocation)
          Positioned(
            top: r.screenHeight * 0.06,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: r.spaceMD,
                  vertical: r.spaceXS,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: r.iconSM,
                      height: r.iconSM,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: r.spaceXS),
                    Text(
                      'Getting your location...',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.fontSM,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Recenter FAB
        Positioned(
          right: r.spaceMD,
          bottom: r.screenHeight * 0.38,
          child: GestureDetector(
            onTap: _recenterMap,
            child: Container(
              width: r.screenWidth * 0.11,
              height: r.screenWidth * 0.11,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius:
                BorderRadius.circular(r.radiusMD),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Icon(
                Icons.my_location,
                color: Colors.white,
                size: r.iconSM,
              ),
            ),
          ),
        ),

        // Bottom sheet
        DraggableScrollableSheet(
          initialChildSize: 0.38,
          minChildSize: 0.12,
          maxChildSize: 0.85,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                      color: AppColors.borderAlt, width: 1),
                ),
              ),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.symmetric(
                    horizontal: r.spaceMD),
                children: [

                  // Drag handle
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(
                          vertical: r.spaceSM),
                      width: r.screenWidth * 0.1,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius:
                        BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceXS),

                  // Search bar
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, __, ___) =>
                          const SearchScreen(),
                          transitionsBuilder:
                              (_, animation, __, child) =>
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 1),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                )),
                                child: child,
                              ),
                          transitionDuration: const Duration(
                              milliseconds: 400),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: r.spaceMD,
                        vertical: r.spaceMD,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(
                            r.radiusLG),
                        border: Border.all(
                            color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.all(r.spaceXS),
                            decoration: BoxDecoration(
                              color: AppColors.orange
                                  .withOpacity(0.15),
                              borderRadius:
                              BorderRadius.circular(
                                  r.radiusSM),
                            ),
                            child: Icon(
                              Icons.search,
                              color: AppColors.orange,
                              size: r.iconSM,
                            ),
                          ),
                          SizedBox(width: r.spaceSM),
                          Text(
                            'Where are you going?',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: r.fontMD,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: r.spaceLG),

                  // Recent searches label
                  Text(
                    'RECENT SEARCHES',
                    style: TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: r.fontXS,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                    ),
                  ),

                  SizedBox(height: r.spaceSM),

                  // Recent searches
                  ..._recentSearches.map(
                        (place) => _RecentSearchTile(
                      name: place['name']!,
                      address: place['address']!,
                      r: r,
                    ),
                  ),

                  SizedBox(height: r.spaceLG),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

// ─── Recent Search Tile ────────────────────────────────

class _RecentSearchTile extends StatelessWidget {
  final String name;
  final String address;
  final Responsive r;

  const _RecentSearchTile({
    required this.name,
    required this.address,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: r.spaceSM),
      padding: EdgeInsets.symmetric(
        horizontal: r.spaceMD,
        vertical: r.spaceMD,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.radiusLG),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(r.spaceXS),
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(r.radiusSM),
            ),
            child: Icon(
              Icons.access_time,
              color: AppColors.textMuted,
              size: r.iconSM,
            ),
          ),
          SizedBox(width: r.spaceMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.fontMD,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: r.spaceXS * 0.5),
                Text(
                  address,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: r.fontSM,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.border,
            size: r.iconSM * 0.75,
          ),
        ],
      ),
    );
  }
}