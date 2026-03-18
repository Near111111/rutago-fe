import 'package:flutter/material.dart';

class Responsive {
  final BuildContext context;
  late final double screenWidth;
  late final double screenHeight;
  late final double statusBarHeight;
  late final double bottomBarHeight;

  Responsive(this.context) {
    final mediaQuery = MediaQuery.of(context);
    screenWidth = mediaQuery.size.width;
    screenHeight = mediaQuery.size.height;
    statusBarHeight = mediaQuery.padding.top;
    bottomBarHeight = mediaQuery.padding.bottom;
  }

  // Font sizes
  double get fontXS => screenWidth * 0.028;   // ~11sp
  double get fontSM => screenWidth * 0.032;   // ~12sp
  double get fontMD => screenWidth * 0.036;   // ~14sp
  double get fontLG => screenWidth * 0.040;   // ~16sp
  double get fontXL => screenWidth * 0.048;   // ~19sp
  double get font2XL => screenWidth * 0.056;  // ~22sp
  double get font3XL => screenWidth * 0.072;  // ~28sp
  double get font4XL => screenWidth * 0.090;  // ~35sp

  // Spacing
  double get spaceXS => screenWidth * 0.02;   // ~8px
  double get spaceSM => screenWidth * 0.03;   // ~12px
  double get spaceMD => screenWidth * 0.04;   // ~16px
  double get spaceLG => screenWidth * 0.06;   // ~24px
  double get spaceXL => screenWidth * 0.08;   // ~32px
  double get space2XL => screenWidth * 0.12;  // ~48px

  // Border radius
  double get radiusSM => screenWidth * 0.02;  // ~8px
  double get radiusMD => screenWidth * 0.03;  // ~12px
  double get radiusLG => screenWidth * 0.04;  // ~16px
  double get radiusXL => screenWidth * 0.06;  // ~24px

  // Icon sizes
  double get iconSM => screenWidth * 0.04;    // ~16px
  double get iconMD => screenWidth * 0.05;    // ~20px
  double get iconLG => screenWidth * 0.06;    // ~24px
  double get iconXL => screenWidth * 0.08;    // ~32px

  // Component sizes
  double get buttonHeight => screenHeight * 0.065;
  double get bottomNavHeight => screenHeight * 0.08;
  double get searchBarHeight => screenHeight * 0.07;
  double get cardPadding => screenWidth * 0.04;
}