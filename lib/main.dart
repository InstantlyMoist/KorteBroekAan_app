import 'package:flutter/material.dart';
import 'package:kortebroekaan/screens/home_screen.dart';
import 'package:kortebroekaan/screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
      MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          '/home': (context) => const HomeScreen(),
        },
      ),
  );
}