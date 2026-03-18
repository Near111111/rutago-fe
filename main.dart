import 'package:flutter/material.dart';
import 'package:ruta_go/screens/splash_screen.dart';
import 'package:ruta_go/theme/app_theme.dart';

void main() {
  runApp(const RutaGoApp());
}

class RutaGoApp extends StatelessWidget {
  const RutaGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RutaGo',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}