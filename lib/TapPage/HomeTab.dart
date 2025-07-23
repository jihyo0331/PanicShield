import 'package:flutter/material.dart';
import 'package:panicshield/home.dart';
import 'ChatTab.dart';
import 'MyPageTab.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        automaticallyImplyLeading: false,
      ),
      body: Center(child: Text("홈 화면")),
    );
  }
}
