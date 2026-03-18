import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';
import 'package:ruta_go/screens/navigation_screen.dart';

class RouteResultScreen extends StatefulWidget {
  final String origin;
  final String destination;

  const RouteResultScreen({
    super.key,
    required this.origin,
    required this.destination,
  });

  @override
  State<RouteResultScreen> createState() => _RouteResultScreenState();
}

class _RouteResultScreenState extends State<RouteResultScreen> {
  final MapController _mapController = MapController();

  final List<LatLng> _routePoints = [
    LatLng(14.5995, 120.9842),
    LatLng(14.6050, 120.9900),
    LatLng(14.6100, 121.0000),
    LatLng(14.6000, 121.0300),
    LatLng(14.5547, 121.0175),
    LatLng(14.5350, 121.0200),
  ];

  final List<CommuteStep> _steps = [
    CommuteStep(
      type: TransportType.walk,
      instruction: 'Walk to LRT-1 Station',
      from: 'Your Location',
      to: 'UN Avenue Station',
      duration: '5 mins',
      distance: '350m',
      fare: null,
    ),
    CommuteStep(
      type: TransportType.lrt,
      instruction: 'Ride LRT-1 Northbound',
      from: 'UN Avenue Station',
      to: 'Taft Avenue Station',
      duration: '8 mins',
      distance: '2.1 km',
      fare: '₱30',
    ),
    CommuteStep(
      type: TransportType.mrt,
      instruction: 'Ride MRT-3 Southbound',
      from: 'Taft Avenue Station',
      to: 'Ayala Station',
      duration: '15 mins',
      distance: '7.8 km',
      fare: '₱28',
    ),
    CommuteStep(
      type: TransportType.walk,
      instruction: 'Walk to destination',
      from: 'Ayala Station',
      to: 'BGC High Street',
      duration: '10 mins',
      distance: '750m',
      fare: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [

          // Map — top 45% of screen
          SizedBox(
            height: r.screenHeight * 0.45,
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(14.5750, 121.0100),
                initialZoom: 13,
              ),
              children: [
                TileLayer(
                  urlTemplate:
                  'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  subdomains: const ['a', 'b', 'c', 'd'],
                  userAgentPackageName: 'com.example.ruta_go',
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: _routePoints,
                      strokeWidth: r.screenWidth * 0.01,
                      color: Colors.white,
                    ),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _routePoints.first,
                      width: r.screenWidth * 0.1,
                      height: r.screenWidth * 0.1,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.background,
                            width: 3,
                          ),
                        ),
                      ),
                    ),
                    Marker(
                      point: _routePoints.last,
                      width: r.screenWidth * 0.1,
                      height: r.screenWidth * 0.1,
                      child: Container(
                        padding: EdgeInsets.all(r.spaceXS * 0.5),
                        decoration: const BoxDecoration(
                          color: AppColors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: r.iconSM,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Back button
          Positioned(
            top: r.screenHeight * 0.06,
            left: r.spaceMD,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: EdgeInsets.all(r.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(r.radiusMD),
                  border: Border.all(color: AppColors.border),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                  size: r.iconMD,
                ),
              ),
            ),
          ),

          // Bottom sheet
          Positioned(
            top: r.screenHeight * 0.40,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(color: AppColors.borderAlt),
                ),
              ),
              child: Column(
                children: [

                  // Drag handle
                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: r.spaceSM),
                      width: r.screenWidth * 0.1,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  // Scrollable content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: r.spaceMD),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Origin → Destination
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.origin,
                                      style: TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: r.fontSM,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: r.spaceXS * 0.5),
                                    Text(
                                      widget.destination,
                                      style: TextStyle(
                                        color: AppColors.textPrimary,
                                        fontSize: r.fontXL,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: r.spaceMD),

                          // Summary cards
                          Row(
                            children: [
                              _SummaryCard(
                                icon: Icons.access_time,
                                label: 'Total Time',
                                value: '38 mins',
                                r: r,
                              ),
                              SizedBox(width: r.spaceSM),
                              _SummaryCard(
                                icon: Icons.route,
                                label: 'Distance',
                                value: '11.0 km',
                                r: r,
                              ),
                              SizedBox(width: r.spaceSM),
                              _SummaryCard(
                                icon: Icons.payments_outlined,
                                label: 'Est. Fare',
                                value: '₱58',
                                r: r,
                              ),
                            ],
                          ),

                          SizedBox(height: r.spaceLG),

                          // Route steps label
                          Text(
                            'ROUTE STEPS',
                            style: TextStyle(
                              color: AppColors.textDisabled,
                              fontSize: r.fontXS,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),

                          SizedBox(height: r.spaceSM),

                          // Steps
                          ..._steps.asMap().entries.map((entry) {
                            return _CommuteStepTile(
                              step: entry.value,
                              isLast: entry.key == _steps.length - 1,
                              r: r,
                            );
                          }),

                          SizedBox(height: r.spaceLG),

                          // Start Navigation button
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      NavigationScreen(
                                        origin: widget.origin,
                                        destination: widget.destination,
                                      ),
                                  transitionsBuilder:
                                      (_, animation, __, child) =>
                                      FadeTransition(
                                        opacity: animation,
                                        child: child,
                                      ),
                                  transitionDuration:
                                  const Duration(milliseconds: 400),
                                ),
                              );
                            },
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                vertical: r.spaceMD,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(r.radiusLG),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.navigation,
                                    color: Colors.black,
                                    size: r.iconMD,
                                  ),
                                  SizedBox(width: r.spaceXS),
                                  Text(
                                    'Start Navigation',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: r.fontLG,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: r.spaceLG),
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

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Responsive r;

  const _SummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(r.spaceSM),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(r.radiusLG),
          border: Border.all(color: AppColors.borderAlt),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: AppColors.textSecondary,
              size: r.iconSM,
            ),
            SizedBox(height: r.spaceXS),
            Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: r.fontLG,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.fontXS,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CommuteStepTile extends StatelessWidget {
  final CommuteStep step;
  final bool isLast;
  final Responsive r;

  const _CommuteStepTile({
    required this.step,
    required this.isLast,
    required this.r,
  });

  IconData get _icon {
    switch (step.type) {
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

  Color get _color {
    switch (step.type) {
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
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Timeline
          Column(
            children: [
              Container(
                width: r.screenWidth * 0.09,
                height: r.screenWidth * 0.09,
                decoration: BoxDecoration(
                  color: _color.withOpacity(0.15),
                  shape: BoxShape.circle,
                  border: Border.all(color: _color.withOpacity(0.3)),
                ),
                child: Icon(_icon, color: _color, size: r.iconSM),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    margin: EdgeInsets.symmetric(
                        vertical: r.spaceXS * 0.5),
                    color: AppColors.border,
                  ),
                ),
            ],
          ),

          SizedBox(width: r.spaceSM),

          // Step details
          Expanded(
            child: Padding(
              padding:
              EdgeInsets.only(bottom: isLast ? 0 : r.spaceMD),
              child: Container(
                padding: EdgeInsets.all(r.spaceSM),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(r.radiusLG),
                  border: Border.all(color: AppColors.borderAlt),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.instruction,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: r.fontMD,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: r.spaceXS * 0.5),
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: AppColors.textMuted,
                          size: r.iconSM * 0.5,
                        ),
                        SizedBox(width: r.spaceXS * 0.5),
                        Expanded(
                          child: Text(
                            step.from,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: r.fontSM,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spaceXS * 0.25),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: _color,
                          size: r.iconSM * 0.75,
                        ),
                        SizedBox(width: r.spaceXS * 0.5),
                        Expanded(
                          child: Text(
                            step.to,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: r.fontSM,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: r.spaceXS),
                    Row(
                      children: [
                        _StepChip(
                          label: step.duration,
                          icon: Icons.access_time,
                          r: r,
                        ),
                        SizedBox(width: r.spaceXS * 0.5),
                        _StepChip(
                          label: step.distance,
                          icon: Icons.straighten,
                          r: r,
                        ),
                        if (step.fare != null) ...[
                          SizedBox(width: r.spaceXS * 0.5),
                          _StepChip(
                            label: step.fare!,
                            icon: Icons.payments_outlined,
                            r: r,
                            highlight: true,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Responsive r;
  final bool highlight;

  const _StepChip({
    required this.label,
    required this.icon,
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
            : AppColors.surfaceAlt,
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
            color: highlight
                ? AppColors.orange
                : AppColors.textSecondary,
            size: r.iconSM * 0.75,
          ),
          SizedBox(width: r.spaceXS * 0.5),
          Text(
            label,
            style: TextStyle(
              color: highlight
                  ? AppColors.orange
                  : AppColors.textSecondary,
              fontSize: r.fontXS,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

enum TransportType { walk, mrt, lrt, jeep, bus }

class CommuteStep {
  final TransportType type;
  final String instruction;
  final String from;
  final String to;
  final String duration;
  final String distance;
  final String? fare;

  CommuteStep({
    required this.type,
    required this.instruction,
    required this.from,
    required this.to,
    required this.duration,
    required this.distance,
    this.fare,
  });
}