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
class Onboarding2 extends StatefulWidget {
  final double progress = 0.20;

  @override
  State<Onboarding2> createState() => _Onboarding2State();
}

class _Onboarding2State extends State<Onboarding2> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  final TextEditingController pwCheckController = TextEditingController();

  String? errorMessage;

  // 조건 확인용 상태 변수
  bool isLongEnough = false;
  bool hasSpecialChar = false;
  bool hasUppercase = false;
  bool containsId = false;

  bool isPasswordValid(String password, String id) {
    final hasUpper = password.contains(RegExp(r'[A-Z]'));
    final hasSpecial = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    final isLongEnough = password.length >= 10;
    final containsId = password.toLowerCase().contains(id.toLowerCase());

    return hasUpper && hasSpecial && isLongEnough && !containsId;
  }

  void checkPasswordConditions(String pw, String id) {
    setState(() {
      isLongEnough = pw.length >= 10;
      hasSpecialChar = pw.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
      hasUppercase = pw.contains(RegExp(r'[A-Z]'));

      if (pw.isEmpty || id.isEmpty) {
        containsId = true;
      } else {
        containsId = pw.toLowerCase().contains(id.toLowerCase());
      }

      if (isPasswordValid(pw, id)) errorMessage = null;
    });
  }

  void validateAndContinue() {
    final id = idController.text;
    final pw = pwController.text;
    final pwCheck = pwCheckController.text;

    if (!isPasswordValid(pw, id)) {
      setState(() {
        errorMessage = "비밀번호 조건을 확인해주세요!";
      });
      return;
    }

    if (pw != pwCheck) {
      setState(() {
        errorMessage = "비밀번호가 일치하지 않습니다.";
      });
      return;
    }

    Navigator.push(context, MaterialPageRoute(builder: (_) => Onboarding3()));
  }

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
            Expanded(child: LinearProgressIndicator(value: widget.progress)),
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
            buildTextField("이름", "ex) 홍길동", controller: nameController),
            buildTextField("아이디", "ex) honggle11", controller: idController),
            buildTextField(
              "비밀번호",
              "비밀번호를 입력해 주세요",
              controller: pwController,
              obscure: true,
              onChanged:
                  (value) => checkPasswordConditions(value, idController.text),
            ),
            buildTextField(
              "비밀번호 재확인",
              "비밀번호를 입력해 주세요",
              controller: pwCheckController,
              obscure: true,
            ),
            SizedBox(height: 10),
            if (errorMessage != null)
              Padding(
                padding: EdgeInsets.only(top: 5, bottom: 10),
                child: Text(
                  errorMessage!,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildConditionItem("10자 이상으로 작성해 주세요", isLongEnough),
                buildConditionItem("특수문자를 하나 이상 사용해 주세요", hasSpecialChar),
                buildConditionItem("대문자를 포함해 주세요", hasUppercase),
                buildConditionItem(
                  "아이디와 연관되는 문자를 사용하지 말아주세요",
                  idController.text.isNotEmpty &&
                      pwController.text.isNotEmpty &&
                      !containsId,
                ),
              ],
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
                onPressed: validateAndContinue,
                child: Text("계속하기", style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(
    String label,
    String hint, {
    TextEditingController? controller,
    bool obscure = false,
    ValueChanged<String>? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
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

Widget buildConditionItem(String text, bool conditionMet) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(
      children: [
        Icon(
          conditionMet ? Icons.check_circle : Icons.radio_button_unchecked,
          color: conditionMet ? Colors.green : Colors.grey,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13,
            color: conditionMet ? Colors.black : Colors.grey,
          ),
        ),
      ],
    ),
  );
}

// PhoneVerificationPage, SelectInterestView 등은 이후에 이어서 작성됩니다.

// Onboarding 3
class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  final interests = [
    {"title": "스포츠, 헬스", "img": "img/Soccer_ball.png"},
    {"title": "영화, 드라마", "img": "img/Film_projector.png"},
    {"title": "뷰티, 패션", "img": "img/Lipstick.png"},
    {"title": "반려동물", "img": "img/Dog.png"},
    {"title": "재테크, 금융", "img": "img/Money_bag.png"},
    {"title": "게임", "img": "img/Joystick.png"},
    {"title": "독서", "img": "img/Open_book.png"},
  ];

  int? selectedIndex;
  bool skipped = false;

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
            Expanded(child: LinearProgressIndicator(value: 0.4)),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "관심사를 골라주세요",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: interests.length,
                separatorBuilder: (_, __) => SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        skipped = false;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color:
                              isSelected
                                  ? Colors.indigo.shade900
                                  : Colors.indigo,
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected ? Colors.indigo.shade50 : null,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Image.asset(
                            interests[index]["img"]!,
                            width: 30,
                            height: 30,
                          ),
                          SizedBox(width: 10),
                          Text(
                            interests[index]["title"]!,
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  setState(() {
                    selectedIndex = null;
                    skipped = true;
                  });
                },
                child: Text(
                  "선택지중에 없어요",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade900,
                  minimumSize: Size(350, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed:
                    (selectedIndex != null || skipped)
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Onboarding4()),
                          );
                        }
                        : null,
                child: Text("계속하기", style: TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onboarding 4
class Onboarding4 extends StatelessWidget {
  const Onboarding4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("전화번호 인증")),
      body: Center(child: Text("여기에 전화번호 인증 UI를 구현하세요")),
    );
  }
}
