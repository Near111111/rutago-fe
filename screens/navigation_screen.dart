import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';
import 'package:ruta_go/screens/home_screen.dart';

class NavigationScreen extends StatefulWidget {
  final String origin;
  final String destination;

  const NavigationScreen({
    super.key,
    required this.origin,
    required this.destination,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen>
    with TickerProviderStateMixin {
  final MapController _mapController = MapController();
  late AnimationController _alertController;
  late Animation<double> _alertAnimation;

  LatLng _currentPosition = const LatLng(14.5995, 120.9842);
  int _currentStepIndex = 0;
  bool _showAlert = false;
  bool _isNavigating = true;

  // Mock route points
  final List<LatLng> _routePoints = [
    LatLng(14.5995, 120.9842),
    LatLng(14.6050, 120.9900),
    LatLng(14.6100, 121.0000),
    LatLng(14.6000, 121.0300),
    LatLng(14.5547, 121.0175),
    LatLng(14.5350, 121.0200),
  ];

  // Mock commute steps
  final List<NavStep> _steps = [
    NavStep(
      type: TransportType.walk,
      instruction: 'Walk to UN Avenue Station',
      detail: 'Head north on Taft Avenue',
      boardAt: 'Your Location',
      alightAt: 'UN Avenue LRT Station',
      duration: '5 mins',
      distance: '350m',
      fare: null,
    ),
    NavStep(
      type: TransportType.lrt,
      instruction: 'Ride LRT-1 Northbound',
      detail: 'Board at UN Avenue, alight at Taft',
      boardAt: 'UN Avenue Station',
      alightAt: 'Taft Avenue Station',
      duration: '8 mins',
      distance: '2.1 km',
      fare: '₱30',
    ),
    NavStep(
      type: TransportType.mrt,
      instruction: 'Ride MRT-3 Southbound',
      detail: 'Board at Taft, alight at Ayala',
      boardAt: 'Taft Avenue Station',
      alightAt: 'Ayala Station',
      duration: '15 mins',
      distance: '7.8 km',
      fare: '₱28',
    ),
    NavStep(
      type: TransportType.walk,
      instruction: 'Walk to destination',
      detail: 'Head east towards BGC High Street',
      boardAt: 'Ayala Station',
      alightAt: 'BGC High Street',
      duration: '10 mins',
      distance: '750m',
      fare: null,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Alert animation
    _alertController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _alertAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _alertController, curve: Curves.easeOutBack),
    );

    _startLocationTracking();

    // Simulate approaching stop after 5 seconds — demo only
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) _triggerAlightAlert();
    });
  }

  void _startLocationTracking() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) {
      if (mounted) {
        setState(() {
          _currentPosition = LatLng(
            position.latitude,
            position.longitude,
          );
        });
        _mapController.move(_currentPosition, 16);
      }
    });
  }

  void _triggerAlightAlert() {
    setState(() => _showAlert = true);
    _alertController.forward();

    // Auto hide after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _alertController.reverse().then((_) {
          if (mounted) setState(() => _showAlert = false);
        });
      }
    });
  }

  void _nextStep() {
    if (_currentStepIndex < _steps.length - 1) {
      setState(() {
        _currentStepIndex++;
        _showAlert = false;
      });
      _alertController.reset();
    } else {
      _showArrivalDialog();
    }
  }

  void _showArrivalDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final r = Responsive(context);
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.radiusXL),
          ),
          child: Padding(
            padding: EdgeInsets.all(r.spaceLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(r.spaceLG),
                  decoration: BoxDecoration(
                    color: AppColors.orange.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.flag_rounded,
                    color: AppColors.orange,
                    size: r.iconXL,
                  ),
                ),
                SizedBox(height: r.spaceMD),
                Text(
                  'You have arrived!',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.fontXL,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: r.spaceXS),
                Text(
                  widget.destination,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.fontMD,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: r.spaceLG),
                GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HomeScreen(),
                      ),
                          (route) => false,
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: r.spaceMD),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(r.radiusLG),
                    ),
                    child: Text(
                      'Back to Home',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: r.fontMD,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _exitNavigation() {
    showDialog(
      context: context,
      builder: (context) {
        final r = Responsive(context);
        return Dialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(r.radiusXL),
          ),
          child: Padding(
            padding: EdgeInsets.all(r.spaceLG),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exit Navigation?',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: r.fontXL,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: r.spaceXS),
                Text(
                  'Your current route progress will be lost.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: r.fontMD,
                  ),
                ),
                SizedBox(height: r.spaceLG),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: r.spaceMD,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius:
                            BorderRadius.circular(r.radiusLG),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Text(
                            'Cancel',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: r.fontMD,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: r.spaceSM),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                                (route) => false,
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: r.spaceMD,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                            BorderRadius.circular(r.radiusLG),
                          ),
                          child: Text(
                            'Exit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: r.fontMD,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _alertController.dispose();
    super.dispose();
  }

  NavStep get _currentStep => _steps[_currentStepIndex];

  IconData _getIcon(TransportType type) {
    switch (type) {
      case TransportType.walk:
        return Icons.directions_walk;
      case TransportType.mrt:
        return Icons.train;
      case TransportType.lrt:
        return Icons.tram;
      case TransportType.jeep:
        return Icons.airport_shuttle;
      case TransportType.bus:
        return Icons.directions_bus;
    }
  }

  Color _getColor(TransportType type) {
    switch (type) {
      case TransportType.walk:
        return Colors.white;
      case TransportType.mrt:
        return const Color(0xFF4CAF50);
      case TransportType.lrt:
        return const Color(0xFF2196F3);
      case TransportType.jeep:
        return AppColors.orange;
      case TransportType.bus:
        return const Color(0xFF9C27B0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // Fullscreen map
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 16,
            ),
            children: [
              TileLayer(
                urlTemplate:
                'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                subdomains: const ['a', 'b', 'c', 'd'],
                userAgentPackageName: 'com.example.ruta_go',
              ),

              // Route polyline
              PolylineLayer(
                polylines: [
                  // Completed route — dimmed
                  Polyline(
                    points: _routePoints.sublist(
                      0,
                      _currentStepIndex + 1 < _routePoints.length
                          ? _currentStepIndex + 1
                          : _routePoints.length,
                    ),
                    strokeWidth: 4,
                    color: Colors.white.withOpacity(0.2),
                  ),
                  // Remaining route — bright
                  Polyline(
                    points: _routePoints.sublist(
                      _currentStepIndex < _routePoints.length
                          ? _currentStepIndex
                          : _routePoints.length - 1,
                    ),
                    strokeWidth: 4,
                    color: Colors.white,
                  ),
                ],
              ),

              // User location marker
              MarkerLayer(
                markers: [
                  Marker(
                    point: _currentPosition,
                    width: 60,
                    height: 60,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
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
                          width: 16,
                          height: 16,
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

          // Top instruction card
          Positioned(
            top: r.screenHeight * 0.06,
            left: r.spaceMD,
            right: r.spaceMD,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(r.spaceMD),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(r.radiusXL),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Transport icon
                      Container(
                        padding: EdgeInsets.all(r.spaceSM),
                        decoration: BoxDecoration(
                          color: _getColor(_currentStep.type)
                              .withOpacity(0.15),
                          borderRadius: BorderRadius.circular(r.radiusMD),
                          border: Border.all(
                            color: _getColor(_currentStep.type)
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Icon(
                          _getIcon(_currentStep.type),
                          color: _getColor(_currentStep.type),
                          size: r.iconLG,
                        ),
                      ),

                      SizedBox(width: r.spaceSM),

                      // Instruction text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _currentStep.instruction,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: r.fontLG,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: r.spaceXS * 0.5),
                            Text(
                              _currentStep.detail,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: r.fontSM,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Exit button
                      GestureDetector(
                        onTap: _exitNavigation,
                        child: Container(
                          padding: EdgeInsets.all(r.spaceXS),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceAlt,
                            borderRadius:
                            BorderRadius.circular(r.radiusSM),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Icon(
                            Icons.close,
                            color: AppColors.textSecondary,
                            size: r.iconSM,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Step progress indicator
                SizedBox(height: r.spaceXS),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _steps.length,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(
                          horizontal: r.spaceXS * 0.25),
                      width: _currentStepIndex == index
                          ? r.spaceLG
                          : r.spaceXS,
                      height: r.spaceXS * 0.5,
                      decoration: BoxDecoration(
                        color: _currentStepIndex == index
                            ? Colors.white
                            : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Alert — "Approaching stop"
          if (_showAlert)
            Positioned(
              top: r.screenHeight * 0.25,
              left: r.spaceMD,
              right: r.spaceMD,
              child: ScaleTransition(
                scale: _alertAnimation,
                child: Container(
                  padding: EdgeInsets.all(r.spaceMD),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(r.radiusXL),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.orange.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.notifications_active,
                        color: Colors.white,
                        size: r.iconLG,
                      ),
                      SizedBox(width: r.spaceSM),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Approaching your stop!',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: r.fontMD,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(height: r.spaceXS * 0.5),
                            Text(
                              'Get ready to alight at: ${_currentStep.alightAt}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: r.fontSM,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // Bottom card — Next step + ETA
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
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

                  // Drag handle
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: EdgeInsets.only(bottom: r.spaceMD),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  // Alight at info
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: AppColors.orange,
                        size: r.iconSM,
                      ),
                      SizedBox(width: r.spaceXS),
                      Text(
                        'Alight at: ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.fontSM,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _currentStep.alightAt,
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: r.fontSM,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: r.spaceSM),

                  // Stats row
                  Row(
                    children: [
                      _NavChip(
                        icon: Icons.access_time,
                        label: _currentStep.duration,
                        r: r,
                      ),
                      SizedBox(width: r.spaceXS),
                      _NavChip(
                        icon: Icons.straighten,
                        label: _currentStep.distance,
                        r: r,
                      ),
                      if (_currentStep.fare != null) ...[
                        SizedBox(width: r.spaceXS),
                        _NavChip(
                          icon: Icons.payments_outlined,
                          label: _currentStep.fare!,
                          r: r,
                          highlight: true,
                        ),
                      ],
                      const Spacer(),

                      // Step counter
                      Text(
                        'Step ${_currentStepIndex + 1} of ${_steps.length}',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: r.fontXS,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: r.spaceMD),

                  // Next step preview
                  if (_currentStepIndex < _steps.length - 1) ...[
                    Container(
                      padding: EdgeInsets.all(r.spaceSM),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(r.radiusLG),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.arrow_forward,
                            color: AppColors.textMuted,
                            size: r.iconSM,
                          ),
                          SizedBox(width: r.spaceXS),
                          Text(
                            'Next: ',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: r.fontSM,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              _steps[_currentStepIndex + 1].instruction,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: r.fontSM,
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: r.spaceMD),
                  ],

                  // Next step button
                  GestureDetector(
                    onTap: _nextStep,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(vertical: r.spaceMD),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(r.radiusLG),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _currentStepIndex < _steps.length - 1
                                ? Icons.skip_next
                                : Icons.flag_rounded,
                            color: Colors.black,
                            size: r.iconMD,
                          ),
                          SizedBox(width: r.spaceXS),
                          Text(
                            _currentStepIndex < _steps.length - 1
                                ? 'Next Step'
                                : 'I have arrived!',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: r.fontMD,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Nav chip widget
class _NavChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Responsive r;
  final bool highlight;

  const _NavChip({
    required this.icon,
    required this.label,
    required this.r,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.spaceXS,
        vertical: r.spaceXS * 0.5,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.orange.withOpacity(0.15)
            : AppColors.background,
        borderRadius: BorderRadius.circular(r.radiusSM),
        border: Border.all(
          color: highlight
              ? AppColors.orange.withOpacity(0.3)
              : AppColors.border,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: highlight ? AppColors.orange : AppColors.textSecondary,
            size: r.iconSM * 0.75,
          ),
          SizedBox(width: r.spaceXS * 0.5),
          Text(
            label,
            style: TextStyle(
              color: highlight ? AppColors.orange : AppColors.textSecondary,
              fontSize: r.fontXS,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// Models
enum TransportType { walk, mrt, lrt, jeep, bus }

class NavStep {
  final TransportType type;
  final String instruction;
  final String detail;
  final String boardAt;
  final String alightAt;
  final String duration;
  final String distance;
  final String? fare;

  NavStep({
    required this.type,
    required this.instruction,
    required this.detail,
    required this.boardAt,
    required this.alightAt,
    required this.duration,
    required this.distance,
    this.fare,
  });
}