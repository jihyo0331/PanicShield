// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:panicshield/text_styles.dart';
import 'package:panicshield/colors.dart';

void main() => runApp(PanicShieldApp());

final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryBlue,
  minimumSize: Size(350, 60),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);

final ButtonStyle okButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryBlue,
  minimumSize: Size(45, 25),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
);

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
                style: boldTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Onboarding2()),
                  );
                },
                child: Text("시작하기", style: commonbuttonTextStyle),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => LoginPage()),
                  );
                },
                child: Text("로그인하기", style: textbuttonTextStyle),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// 로그인 페이지
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            SizedBox(height: 24),
            Text("로그인을 진행해 주세요", style: boldTextStyle),
            SizedBox(height: 6),
            Text("안녕하세요? 패닉쉴드를 시작하기 위해 로그인을 진행해 주세요", style: explainTextStyle),
            SizedBox(height: 30),

            Text("아이디", style: nameTextStyle),
            TextField(
              decoration: InputDecoration(
                hintText: "아이디를 입력해주세요",
                hintStyle: secretTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
              ),
            ),
            SizedBox(height: 30),

            Text("비밀번호", style: nameTextStyle),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                hintText: "비밀번호를 입력해주세요",
                hintStyle: secretTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: () {
                  // 로그인 로직 또는 다음 화면 이동
                },
                child: Text("로그인 하기", style: commonbuttonTextStyle),
              ),
            ),
            SizedBox(height: 30),
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
    final name = nameController.text.trim();
    final id = idController.text;
    final pw = pwController.text;
    final pwCheck = pwCheckController.text;

    if (name.isEmpty || id.isEmpty || pw.isEmpty || pwCheck.isEmpty) {
      setState(() {
        errorMessage = "모든 항목을 입력해 주세요!";
      });
      return;
    }

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
            Expanded(
              child: LinearProgressIndicator(
                value: 0.17,
                color: primaryBlue,
                backgroundColor: progressGrey,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("회원가입을 진행해 주세요", style: boldTextStyle),
            SizedBox(height: 10),
            Text("안녕하세요? 패닉쉴드를 시작하기 위해 회원가입을 진행해 주세요", style: explainTextStyle),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("이름", style: nameTextStyle),
                SizedBox(height: 5),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: "ex) 홍길동",
                    hintStyle: secretTextStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue, width: 2),
                    ),
                  ),
                ),
                Divider(height: 20, thickness: 1),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("아이디", style: nameTextStyle),
                SizedBox(height: 5),
                TextField(
                  controller: idController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  decoration: InputDecoration(
                    hintText: "ex) honggle11",
                    hintStyle: secretTextStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue),
                    ),
                  ),
                ),
                Divider(height: 20, thickness: 1),
              ],
            ),
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
                  style: TextStyle(color: Colors.red, fontSize: 11),
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
                style: commonButtonStyle,
                onPressed: validateAndContinue,
                child: Text("계속하기", style: commonbuttonTextStyle),
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
        Text(label, style: nameTextStyle),
        SizedBox(height: 5),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: secretTextStyle,
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
          color: conditionMet ? primaryBlue : secretGrey,
          size: 18,
        ),
        SizedBox(width: 8),
        Text(text, style: checklistTextStyle),
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
            Expanded(
              child: LinearProgressIndicator(
                value: 0.34,
                color: primaryBlue,
                backgroundColor: progressGrey,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("관심사를 골라주세요", style: boldTextStyle),
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
                                  ? primaryBlue
                                  : primaryBlue.withOpacity(0.5),
                          width: isSelected ? 2 : 1,
                        ),
                        color: isSelected ? secretGrey : Colors.transparent,
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
                            style: boldTextStyle,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Onboarding4()),
                  );
                },
                child: Text(
                  "선택지 중에 없어요",
                  style: textbuttonTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 12),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed:
                    selectedIndex != null
                        ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => Onboarding4()),
                          );
                        }
                        : null,
                child: Text("계속하기", style: commonbuttonTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onboarding 4
class Onboarding4 extends StatefulWidget {
  const Onboarding4({super.key});

  @override
  State<Onboarding4> createState() => _Onboarding4State();
}

class _Onboarding4State extends State<Onboarding4> {
  final TextEditingController interestController = TextEditingController();
  final List<String> interests = [];
  bool isInputValid = false;

  void handleInput() {
    final input = interestController.text.trim();
    if (input.isNotEmpty) {
      setState(() {
        interests.addAll(
          input
              .split(',')
              .map((e) => e.trim())
              .where((e) => e.isNotEmpty && !interests.contains(e)),
        );
        interestController.clear();
        isInputValid = interests.isNotEmpty;
      });
    }
  }

  void handleContinue() {
    if (interests.isNotEmpty) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => Onboarding5()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: LinearProgressIndicator(
          value: 0.51,
          color: primaryBlue,
          backgroundColor: progressGrey,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("무엇을 좋아하시나요?\n관심사를 세부적으로 입력해 주세요", style: boldTextStyle),
            SizedBox(height: 8),
            Text("수집된 자료는 상황 대처를 목적으로 인공지능이 활용합니다", style: explainTextStyle),
            SizedBox(height: 24),
            TextField(
              controller: interestController,
              decoration: InputDecoration(
                hintText: "ex) 농구, 판타지, 옷, 메이크업",
                suffixIcon: TextButton(
                  style: okButtonStyle,
                  onPressed: handleInput,
                  child: Text("확인", style: okbuttonTextStyle),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
                border: UnderlineInputBorder(),
              ),
              onSubmitted: (_) => handleInput(),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  interests
                      .map(
                        (e) => Chip(
                          label: Text(e),
                          backgroundColor: primaryBlue.withOpacity(0.5),
                          deleteIcon: Icon(Icons.close),
                          onDeleted: () {
                            setState(() {
                              interests.remove(e);
                              isInputValid = interests.isNotEmpty;
                            });
                          },
                        ),
                      )
                      .toList(),
            ),
            SizedBox(height: 8),
            Text(
              "위 예시처럼 단어 형식으로 입력해 주세요. 여러 개 입력시 하나 입력 후 버튼을 눌러 주세요",
              style: explainTextStyle,
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: isInputValid ? handleContinue : null,
                child: Text("계속하기", style: commonbuttonTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Onboarding 5
class Onboarding5 extends StatefulWidget {
  const Onboarding5({super.key});

  @override
  State<Onboarding5> createState() => _Onboarding5State();
}

class _Onboarding5State extends State<Onboarding5> {
  final TextEditingController _controller = TextEditingController();
  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        isInputNotEmpty = _controller.text.trim().isNotEmpty;
      });
    });
  }

  void handleContinue() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => Onboarding6()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 상단 바
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 0.68,
                    color: primaryBlue,
                    backgroundColor: progressGrey,
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            Text("공황발작 발생 시 본인만의\n대처 방법이 있으신가요?", style: boldTextStyle),
            SizedBox(height: 8),
            Text("대처방법이 없다면 아무것도 적지 않고 계속하기를 눌러주세요", style: explainTextStyle),
            SizedBox(height: 32),

            Text("대처방법을 적어주세요"),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: "ex) 다른 생각을 한다",
                hintStyle: secretTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue),
                ),
              ),
            ),

            SizedBox(height: 12),
            Text(
              "위 예시처럼 문장 형식으로 입력해 주세요\n대처 방법을 자세하고 정확하게 적어주세요",
              style: explainTextStyle,
            ),

            Spacer(),

            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: handleContinue,
                child: Text("계속하기", style: commonbuttonTextStyle),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// Onboarding 6
class Onboarding6 extends StatelessWidget {
  const Onboarding6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 50),

            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                Expanded(
                  child: LinearProgressIndicator(
                    value: 1.0,
                    color: primaryBlue,
                    backgroundColor: progressGrey,
                  ),
                ),
              ],
            ),

            Spacer(),

            Center(
              child: Image.asset('img/Handshake.png', width: 160, height: 160),
            ),
            SizedBox(height: 24),

            Text(
              "모든 설정이 끝났어요\n조금만 기다리면\n나만의 방패가 만들어져요",
              style: boldTextStyle,
              textAlign: TextAlign.center,
            ),

            Spacer(),

            ElevatedButton(
              style: commonButtonStyle,
              onPressed: () {},
              child: Text("들어가기", style: commonbuttonTextStyle),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
