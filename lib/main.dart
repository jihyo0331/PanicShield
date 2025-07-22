import 'package:flutter/material.dart';
import 'onboarding.dart';

void main() => runApp(const PanicShieldApp());

class PanicShieldApp extends StatelessWidget {
  const PanicShieldApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Onboarding1(),
    );
  }
}

// Onboarding1과 Onboarding2 위젯은 이전 코드에서 그대로 유지됩니다.
