import 'package:flutter/material.dart';
import 'package:ruta_go/theme/app_theme.dart';
import 'package:ruta_go/utils/responsive.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _mrtEnabled = true;
  bool _lrtEnabled = true;
  bool _busEnabled = true;
  bool _jeepEnabled = true;
  bool _alertsEnabled = true;
  bool _vibrationEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedDistanceUnit = 'Kilometers';

  @override
  Widget build(BuildContext context) {
    final r = Responsive(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Header
            Padding(
              padding: EdgeInsets.fromLTRB(
                r.spaceMD,
                r.spaceMD,
                r.spaceMD,
                0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.font3XL,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(height: r.spaceXS * 0.5),
                  Text(
                    'Customize your experience',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: r.fontSM,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: r.spaceLG),

            Expanded(
              child: SingleChildScrollView(
                padding:
                EdgeInsets.symmetric(horizontal: r.spaceMD),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Transport
                    _SectionLabel(label: 'TRANSPORT', r: r),
                    SizedBox(height: r.spaceSM),
                    _SettingsCard(
                      r: r,
                      children: [
                        _TransportToggle(
                          icon: Icons.train,
                          label: 'MRT',
                          subtitle: 'Metro Rail Transit',
                          color: const Color(0xFF4CAF50),
                          value: _mrtEnabled,
                          r: r,
                          onChanged: (val) =>
                              setState(() => _mrtEnabled = val),
                        ),
                        _Divider(r: r),
                        _TransportToggle(
                          icon: Icons.tram,
                          label: 'LRT',
                          subtitle: 'Light Rail Transit',
                          color: const Color(0xFF2196F3),
                          value: _lrtEnabled,
                          r: r,
                          onChanged: (val) =>
                              setState(() => _lrtEnabled = val),
                        ),
                        _Divider(r: r),
                        _TransportToggle(
                          icon: Icons.directions_bus,
                          label: 'Bus',
                          subtitle: 'Public Bus',
                          color: const Color(0xFF9C27B0),
                          value: _busEnabled,
                          r: r,
                          onChanged: (val) =>
                              setState(() => _busEnabled = val),
                        ),
                        _Divider(r: r),
                        _TransportToggle(
                          icon: Icons.airport_shuttle,
                          label: 'Jeepney',
                          subtitle: 'Traditional Jeepney',
                          color: AppColors.orange,
                          value: _jeepEnabled,
                          r: r,
                          onChanged: (val) =>
                              setState(() => _jeepEnabled = val),
                        ),
                      ],
                    ),

                    SizedBox(height: r.spaceLG),

                    // Notifications
                    _SectionLabel(
                        label: 'NOTIFICATIONS', r: r),
                    SizedBox(height: r.spaceSM),
                    _SettingsCard(
                      r: r,
                      children: [
                        _ToggleTile(
                          icon: Icons.notifications_outlined,
                          label: 'Alight Alerts',
                          subtitle:
                          'Notify when approaching your stop',
                          value: _alertsEnabled,
                          r: r,
                          onChanged: (val) => setState(
                                  () => _alertsEnabled = val),
                        ),
                        _Divider(r: r),
                        _ToggleTile(
                          icon: Icons.vibration,
                          label: 'Vibration',
                          subtitle: 'Vibrate on alerts',
                          value: _vibrationEnabled,
                          r: r,
                          onChanged: (val) => setState(
                                  () => _vibrationEnabled = val),
                        ),
                      ],
                    ),

                    SizedBox(height: r.spaceLG),

                    // Preferences
                    _SectionLabel(
                        label: 'PREFERENCES', r: r),
                    SizedBox(height: r.spaceSM),
                    _SettingsCard(
                      r: r,
                      children: [
                        _SelectTile(
                          icon: Icons.language,
                          label: 'Language',
                          value: _selectedLanguage,
                          options: const [
                            'English',
                            'Filipino'
                          ],
                          r: r,
                          onChanged: (val) => setState(
                                  () => _selectedLanguage = val),
                        ),
                        _Divider(r: r),
                        _SelectTile(
                          icon: Icons.straighten,
                          label: 'Distance Unit',
                          value: _selectedDistanceUnit,
                          options: const [
                            'Kilometers',
                            'Miles'
                          ],
                          r: r,
                          onChanged: (val) => setState(() =>
                          _selectedDistanceUnit = val),
                        ),
                      ],
                    ),

                    SizedBox(height: r.spaceLG),

                    // About
                    _SectionLabel(label: 'ABOUT', r: r),
                    SizedBox(height: r.spaceSM),
                    _SettingsCard(
                      r: r,
                      children: [
                        _InfoTile(
                          icon: Icons.info_outline,
                          label: 'Version',
                          value: 'v1.0.0',
                          r: r,
                        ),
                        _Divider(r: r),
                        _InfoTile(
                          icon: Icons.code,
                          label: 'Developer',
                          value: 'RutaGo Team',
                          r: r,
                        ),
                        _Divider(r: r),
                        _ActionTile(
                          icon: Icons.star_outline,
                          label: 'Rate the App',
                          r: r,
                          onTap: () {},
                        ),
                        _Divider(r: r),
                        _ActionTile(
                          icon: Icons.bug_report_outlined,
                          label: 'Report a Bug',
                          r: r,
                          onTap: () {},
                        ),
                      ],
                    ),

                    SizedBox(height: r.spaceLG),

                    // App credit
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'RutaGo',
                            style: TextStyle(
                              color: AppColors.textDisabled,
                              fontSize: r.fontSM,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                          SizedBox(height: r.spaceXS * 0.5),
                          Text(
                            'Your route, we know it.',
                            style: TextStyle(
                              color: AppColors.textDisabled,
                              fontSize: r.fontXS,
                            ),
                          ),
                        ],
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
    );
  }
}

// ─── Section Label ─────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  final Responsive r;

  const _SectionLabel({required this.label, required this.r});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: AppColors.textDisabled,
        fontSize: r.fontXS,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.5,
      ),
    );
  }
}

// ─── Settings Card ─────────────────────────────────────

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  final Responsive r;

  const _SettingsCard(
      {required this.children, required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(r.radiusLG),
        border: Border.all(color: AppColors.borderAlt),
      ),
      child: Column(children: children),
    );
  }
}

// ─── Divider ───────────────────────────────────────────

class _Divider extends StatelessWidget {
  final Responsive r;
  const _Divider({required this.r});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      margin: EdgeInsets.symmetric(horizontal: r.spaceMD),
      color: AppColors.borderAlt,
    );
  }
}

// ─── Custom Toggle ─────────────────────────────────────

class _CustomToggle extends StatelessWidget {
  final bool value;
  final Color color;
  final Responsive r;
  final ValueChanged<bool> onChanged;

  const _CustomToggle({
    required this.value,
    required this.color,
    required this.r,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final trackWidth = r.screenWidth * 0.13;
    final trackHeight = r.screenWidth * 0.07;
    final thumbSize = trackHeight - 6;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: trackWidth,
        height: trackHeight,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value
              ? color.withOpacity(0.25)
              : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: value
                ? color.withOpacity(0.5)
                : AppColors.border,
            width: 1.5,
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          alignment: value
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
            width: thumbSize,
            height: thumbSize,
            decoration: BoxDecoration(
              color: value ? color : AppColors.textMuted,
              borderRadius: BorderRadius.circular(999),
              boxShadow: value
                  ? [
                BoxShadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Transport Toggle ──────────────────────────────────

class _TransportToggle extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final bool value;
  final Responsive r;
  final ValueChanged<bool> onChanged;

  const _TransportToggle({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.value,
    required this.r,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: EdgeInsets.all(r.spaceMD),
        child: Row(
          children: [

            // Icon container
            Container(
              width: r.screenWidth * 0.12,
              height: r.screenWidth * 0.12,
              decoration: BoxDecoration(
                color: value
                    ? color.withOpacity(0.15)
                    : AppColors.surfaceAlt,
                borderRadius:
                BorderRadius.circular(r.radiusMD),
                border: Border.all(
                  color: value
                      ? color.withOpacity(0.3)
                      : AppColors.border,
                ),
              ),
              child: Icon(
                icon,
                color:
                value ? color : AppColors.textMuted,
                size: r.iconMD,
              ),
            ),

            SizedBox(width: r.spaceMD),

            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: value
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: r.spaceXS * 0.25),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: r.fontXS,
                    ),
                  ),
                ],
              ),
            ),

            // Custom toggle
            _CustomToggle(
              value: value,
              color: color,
              r: r,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Toggle Tile ───────────────────────────────────────

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool value;
  final Responsive r;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.value,
    required this.r,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: Padding(
        padding: EdgeInsets.all(r.spaceMD),
        child: Row(
          children: [

            // Icon container
            Container(
              width: r.screenWidth * 0.12,
              height: r.screenWidth * 0.12,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius:
                BorderRadius.circular(r.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                color: value
                    ? AppColors.textPrimary
                    : AppColors.textMuted,
                size: r.iconMD,
              ),
            ),

            SizedBox(width: r.spaceMD),

            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: r.fontMD,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: r.spaceXS * 0.25),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: r.fontXS,
                    ),
                  ),
                ],
              ),
            ),

            // Custom toggle — white
            _CustomToggle(
              value: value,
              color: Colors.white,
              r: r,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Select Tile ───────────────────────────────────────

class _SelectTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final Responsive r;
  final ValueChanged<String> onChanged;

  const _SelectTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.r,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showOptions(context),
      child: Padding(
        padding: EdgeInsets.all(r.spaceMD),
        child: Row(
          children: [

            // Icon container
            Container(
              width: r.screenWidth * 0.12,
              height: r.screenWidth * 0.12,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius:
                BorderRadius.circular(r.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary,
                size: r.iconMD,
              ),
            ),

            SizedBox(width: r.spaceMD),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: r.fontMD,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              value,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: r.fontSM,
              ),
            ),

            SizedBox(width: r.spaceXS),

            Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: r.iconSM,
            ),
          ],
        ),
      ),
    );
  }

  void _showOptions(BuildContext context) {
    final r = Responsive(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        padding: EdgeInsets.all(r.spaceMD),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Handle
            Center(
              child: Container(
                width: r.screenWidth * 0.1,
                height: 4,
                margin:
                EdgeInsets.only(bottom: r.spaceMD),
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius:
                  BorderRadius.circular(999),
                ),
              ),
            ),

            Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: r.fontXL,
                fontWeight: FontWeight.w700,
              ),
            ),

            SizedBox(height: r.spaceMD),

            ...options.map((option) => GestureDetector(
              onTap: () {
                onChanged(option);
                Navigator.pop(context);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(r.spaceMD),
                margin: EdgeInsets.only(
                    bottom: r.spaceXS),
                decoration: BoxDecoration(
                  color: value == option
                      ? Colors.white
                      : AppColors.surfaceAlt,
                  borderRadius:
                  BorderRadius.circular(r.radiusLG),
                  border: Border.all(
                    color: value == option
                        ? Colors.white
                        : AppColors.border,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: value == option
                              ? Colors.black
                              : AppColors.textPrimary,
                          fontSize: r.fontMD,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (value == option)
                      Icon(
                        Icons.check,
                        color: Colors.black,
                        size: r.iconSM,
                      ),
                  ],
                ),
              ),
            )),

            SizedBox(height: r.spaceSM),
          ],
        ),
      ),
    );
  }
}

// ─── Info Tile ─────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Responsive r;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.r,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(r.spaceMD),
      child: Row(
        children: [

          // Icon container
          Container(
            width: r.screenWidth * 0.12,
            height: r.screenWidth * 0.12,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(r.radiusMD),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(
              icon,
              color: AppColors.textSecondary,
              size: r.iconMD,
            ),
          ),

          SizedBox(width: r.spaceMD),

          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: r.fontMD,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            value,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: r.fontSM,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Action Tile ───────────────────────────────────────

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Responsive r;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.r,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(r.spaceMD),
        child: Row(
          children: [

            // Icon container
            Container(
              width: r.screenWidth * 0.12,
              height: r.screenWidth * 0.12,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius:
                BorderRadius.circular(r.radiusMD),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                icon,
                color: AppColors.textSecondary,
                size: r.iconMD,
              ),
            ),

            SizedBox(width: r.spaceMD),

            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: r.fontMD,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
              size: r.iconSM,
            ),
          ],
        ),
      ),
    );
  }
}