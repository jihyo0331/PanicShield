import 'package:flutter/material.dart';
import 'onboarding.dart';
import 'home.dart';

void main() => runApp(const PanicShieldApp());

class PanicShieldApp extends StatelessWidget {
  const PanicShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontWeight: FontWeight.w500), // Medium
          bodyLarge: TextStyle(fontWeight: FontWeight.w700), // Bold
        ),
      ),
      home: Home(),
    );
  }
}
