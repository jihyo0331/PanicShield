import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'onboarding.dart';
import 'home.dart';
import 'language_manager.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => LanguageManager(),
    child: const PanicShieldApp(),
  ),
);

class PanicShieldApp extends StatelessWidget {
  const PanicShieldApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Onboarding1(),
    );
  }
}
