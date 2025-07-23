// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

void main() => runApp(PanicShieldApp());

class PanicShieldApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Onboarding1());
  }
}

class PhoneVerificationPage extends StatelessWidget {
  const PhoneVerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("전화번호 인증")),
      body: const Center(child: Text("여기에 전화번호 인증 UI 작성")),
    );
  }
}

// Onboarding 1
class Onboarding1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: GestureDetector(
                onTap: () {},
                child: Image.asset('img/ko.png', width: 40, height: 52),
              ),
            ),
            SizedBox(height: 100),
            Center(
              child: Image.asset(
                'img/Waving_hand.png',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 30),

            Center(
              child: Text(
                "안녕하세요?\n나만의 방패 패닉쉴드에요",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  minimumSize: Size(350, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Onboarding2()),
                  );
                },
                child: Text("시작하기", style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 10),
            Center(child: Text("로그인하기", style: TextStyle(fontSize: 14))),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// Onboarding 2
class Onboarding2 extends StatelessWidget {
  final double progress = 0.20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () => Navigator.pop(context),
            ),
            Expanded(child: LinearProgressIndicator(value: progress)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "회원가입을 진행해 주세요",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "안녕하세요? 패닉쉴드를 시작하기 위해 회원가입을 진행해 주세요",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 20),
            buildTextField("이름", "ex) 홍길동"),
            buildTextField("아이디", "ex) honggle11"),
            buildTextField("비밀번호", "비밀번호를 입력해 주세요", obscure: true),
            SizedBox(height: 10),
            Text(
              "• 10자 이상\n• 특수문자 1개 이상\n• 대문자 포함\n• 아이디와 유사한 문자 X",
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  minimumSize: Size(350, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PhoneVerificationPage()),
                  );
                },
                child: Text("계속하기", style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String hint, {bool obscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        TextField(
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        Divider(height: 20, thickness: 1),
      ],
    );
  }
}

// PhoneVerificationPage, SelectInterestView 등은 이후에 이어서 작성됩니다.
