import 'package:flutter/material.dart';
import 'package:ruta_go/screens/splash_screen.dart'; // ← changed

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
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFFFFFF),
          secondary: Color(0xFFFF6D00),
          surface: Color(0xFF141414),
        ),
      ),
      home: const SplashScreen(), // ← changed
    );
  }
}