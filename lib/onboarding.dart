// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:panicshield/text_styles.dart';
import 'package:panicshield/colors.dart';
import 'home.dart';
import 'language_manager.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(PanicShieldApp());
}

// Onboarding Constants
const double kProgressBarHeight = 17.0;
const int kOnboardingTotalSteps = 7;
const double kProgressBarRadius = 8.0;
final Map<String, dynamic> registrationData = {};
bool _isKorean = true;

final ButtonStyle commonButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryBlue,
  minimumSize: Size(400, 75),
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
);

final ButtonStyle okButtonStyle = ElevatedButton.styleFrom(
  backgroundColor: primaryBlue,
  minimumSize: Size(90, 25),
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

// 온보딩 1
class Onboarding1 extends StatefulWidget {
  const Onboarding1({super.key});

  @override
  State<Onboarding1> createState() => _Onboarding1State();
}

class _Onboarding1State extends State<Onboarding1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isKorean = !_isKorean;
                    // Sync with LanguageManager
                    Provider.of<LanguageManager>(context, listen: false)
                        .isKorean = _isKorean;
                  });
                },
                child: Image.asset(
                  _isKorean ? 'img/ko.png' : 'img/en.png',
                  width: 40,
                  height: 52,
                ),
              ),
            ),
            SizedBox(height: 300),
            Align(
              alignment: Alignment(-0.2, 0),
              child: Image.asset(
                'img/Waving_hand.png',
                width: 200,
                height: 200,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                _isKorean
                    ? "안녕하세요?\n나만의 방패 패닉쉴드에요"
                    : "Hello!\nI’m PanicShield,\nmy own shield.",
                style: boldTextStyle,
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 200),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Onboarding2()),
                  );
                },
                child: Text(
                  _isKorean ? "시작하기" : "Get Started",
                  style: commonbuttonTextStyle,
                ),
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
                child: Text(
                  _isKorean ? "로그인하기" : "Log in",
                  style: textbuttonTextStyle,
                ),
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
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();

  @override
  void dispose() {
    idController.dispose();
    pwController.dispose();
    super.dispose();
  }

  Future<void> handleLogin() async {
    final id = idController.text.trim();
    final pw = pwController.text;
    try {
      final res = await http.post(
        Uri.parse('https://panicshield.ngrok.dev/api/auth/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': id, 'password': pw}),
      );
      if (res.statusCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => Home()),
          (Route<dynamic> route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isKorean ? '로그인에 실패했습니다.' : 'Login failed')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isKorean ? '네트워크 오류가 발생했습니다.' : 'Network error'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: 100),
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
            Text(
              _isKorean ? "로그인을 진행해 주세요" : "Log in to continue",
              style: boldTextStyle,
            ),
            SizedBox(height: 6),
            Text(
              _isKorean
                  ? "안녕하세요? 패닉쉴드를 시작하기 위해 로그인을 진행해 주세요"
                  : "Hello! Please log in to get started with PanicShield.",
              style: explainTextStyle,
            ),
            SizedBox(height: 80),
            Text(_isKorean ? "아이디" : "User ID", style: nameTextStyle),
            TextField(
              controller: idController,
              decoration: InputDecoration(
                hintText: _isKorean ? "아이디를 입력해주세요" : "Enter your user ID",
                hintStyle: secretTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue, width: 2),
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(_isKorean ? "비밀번호" : "Password", style: nameTextStyle),
            TextField(
              controller: pwController,
              obscureText: true,
              decoration: InputDecoration(
                hintText: _isKorean ? "비밀번호를 입력해주세요" : "Enter your password",
                hintStyle: secretTextStyle,
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue, width: 2),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: primaryBlue, width: 2),
                ),
              ),
            ),
            Spacer(),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: handleLogin,
                child: Text(
                  _isKorean ? "로그인 하기" : "Login",
                  style: commonbuttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 온보딩 2
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

  Future<void> validateAndContinue() async {
    final name = nameController.text.trim();
    final id = idController.text;
    final pw = pwController.text;
    final pwCheck = pwCheckController.text;

    if (name.isEmpty || id.isEmpty || pw.isEmpty || pwCheck.isEmpty) {
      setState(() {
        errorMessage =
            _isKorean ? "모든 항목을 입력해 주세요!" : "Please fill out all fields.";
      });
      return;
    }

    if (!isPasswordValid(pw, id)) {
      setState(() {
        errorMessage =
            _isKorean
                ? "비밀번호 조건을 확인해주세요!"
                : "Please check the password conditions!";
      });
      return;
    }

    if (pw != pwCheck) {
      setState(() {
        errorMessage =
            _isKorean ? "비밀번호가 일치하지 않습니다." : "Passwords do not match.";
      });
      return;
    }

    // 회원가입 API 호출 로직 삭제. 다음 온보딩으로 이동
    registrationData['name'] = name;
    registrationData['username'] = id;
    registrationData['password'] = pw;
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kProgressBarRadius),
                child: LinearProgressIndicator(
                  minHeight: kProgressBarHeight,
                  value: 0.17,
                  color: primaryBlue,
                  backgroundColor: progressGrey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isKorean ? "회원가입을 진행해 주세요" : "Please proceed with the sign up.",
              style: _isKorean ? boldTextStyle : en_boldTextStyle,
            ),
            SizedBox(height: 10),
            Text(
              _isKorean
                  ? "안녕하세요? 패닉쉴드를 시작하기 위해 회원가입을 진행해 주세요"
                  : "Hello! Please proceed with the sign-up to start PanicShield.",
              style: _isKorean ? explainTextStyle : en_explainTextStyle,
            ),
            SizedBox(height: 60),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_isKorean ? "이름" : "name", style: nameTextStyle),
                SizedBox(height: 1),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    hintText: _isKorean ? "ex) 홍길동" : "ex) HongGildong",
                    hintStyle: secretTextStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue, width: 2),
                    ),
                  ),
                ),
                // Divider removed
              ],
            ),
            SizedBox(height: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_isKorean ? "아이디" : "user ID", style: nameTextStyle),
                SizedBox(height: 1),
                TextField(
                  controller: idController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
                  ],
                  decoration: InputDecoration(
                    hintText: "ex) honggle11",
                    hintStyle: secretTextStyle,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue, width: 2),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryBlue, width: 2),
                    ),
                  ),
                ),
                // Divider removed
              ],
            ),
            SizedBox(height: 30),
            buildTextField(
              _isKorean ? "비밀번호" : "password",
              _isKorean ? "비밀번호를 입력해 주세요" : "please enter your password",
              controller: pwController,
              obscure: true,
              onChanged:
                  (value) => checkPasswordConditions(value, idController.text),
            ),
            SizedBox(height: 30),
            buildTextField(
              _isKorean ? "비밀번호 재확인" : "confirm password",
              _isKorean ? "비밀번호를 입력해 주세요" : "please re-enter your password",
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
                buildConditionItem(
                  _isKorean ? "10자 이상으로 작성해 주세요" : "At least 10 characters.",
                  isLongEnough,
                ),
                buildConditionItem(
                  _isKorean
                      ? "특수문자를 하나 이상 사용해 주세요"
                      : "Include at least one special character.",
                  hasSpecialChar,
                ),
                buildConditionItem(
                  _isKorean ? "대문자를 포함해 주세요" : "Include an uppercase letter.",
                  hasUppercase,
                ),
                buildConditionItem(
                  _isKorean
                      ? "아이디와 연관되는 문자를 사용하지 말아주세요"
                      : "Avoid using characters related to the username.",
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
                child: Text(
                  _isKorean ? "계속하기" : "Continue",
                  style: commonbuttonTextStyle,
                ),
              ),
            ),
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
        SizedBox(height: 0.5),
        TextField(
          controller: controller,
          obscureText: obscure,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: secretTextStyle,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryBlue, width: 2),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: primaryBlue, width: 2),
            ),
          ),
        ),
        // Divider removed
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

// 온보딩 3
class Onboarding3 extends StatefulWidget {
  const Onboarding3({super.key});

  @override
  State<Onboarding3> createState() => _Onboarding3State();
}

class _Onboarding3State extends State<Onboarding3> {
  final interests = [
    {
      "title": _isKorean ? "스포츠, 헬스" : "Sports, Health",
      "img": "img/Soccer_ball.png",
    },
    {
      "title": _isKorean ? "영화, 드라마" : "Movie, Drama",
      "img": "img/Film_projector.png",
    },
    {
      "title": _isKorean ? "뷰티, 패션" : "Beauty, Fashion",
      "img": "img/Lipstick.png",
    },
    {"title": _isKorean ? "반려동물" : "Pet", "img": "img/Dog.png"},
    {
      "title": _isKorean ? "재테크, 금융" : "Investment, Finance",
      "img": "img/Money_bag.png",
    },
    {"title": _isKorean ? "게임" : "Game", "img": "img/Joystick.png"},
    {"title": _isKorean ? "독서" : "Reading", "img": "img/Open_book.png"},
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(kProgressBarRadius),
                child: LinearProgressIndicator(
                  minHeight: kProgressBarHeight,
                  value: 0.34,
                  color: primaryBlue,
                  backgroundColor: progressGrey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isKorean ? "관심사를 골라주세요" : "Please select your interests.",
              style: boldTextStyle,
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
                  _isKorean ? "선택지 중에 없어요" : "Not on the list.",
                  style: textbuttonTextStyle,
                  textAlign: TextAlign.center,
                ),
              ),
            ),

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
                child: Text(
                  _isKorean ? "계속하기" : "Continue",
                  style: commonbuttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 온보딩 4
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
      registrationData['interests'] = interests;
      Navigator.push(context, MaterialPageRoute(builder: (_) => Onboarding5()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: ClipRRect(
          borderRadius: BorderRadius.circular(kProgressBarRadius),
          child: LinearProgressIndicator(
            minHeight: kProgressBarHeight,
            value: 0.51,
            color: primaryBlue,
            backgroundColor: progressGrey,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isKorean
                  ? "무엇을 좋아하시나요?\n관심사를 세부적으로 입력해 주세요"
                  : "What do you like?\nEnter details.",
              style: boldTextStyle,
            ),
            SizedBox(height: 8),
            Text(
              _isKorean
                  ? "수집된 자료는 상황 대처를 목적으로 인공지능이 활용합니다"
                  : "Collected data is used by AI for situational response.",
              style: explainTextStyle,
            ),
            SizedBox(height: 250),
            TextField(
              controller: interestController,
              decoration: InputDecoration(
                hintText:
                    _isKorean
                        ? "ex) 농구, 판타지, 옷, 메이크업"
                        : "ex) Basketball, Fantasy, Clothes, Makeup",
                suffixIcon: TextButton(
                  style: okButtonStyle,
                  onPressed: handleInput,
                  child: Text(
                    _isKorean ? "확인" : "OK",
                    style: okbuttonTextStyle,
                  ),
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
              _isKorean
                  ? "위 예시처럼 단어 형식으로 입력해 주세요.\n여러 개 입력시 하나 입력 후 버튼을 눌러 주세요"
                  : "Enter in word format like the example above.\nFor multiple entries, enter one and press the button.",
              style: explainTextStyle,
            ),

            Spacer(),
            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: isInputValid ? handleContinue : null,
                child: Text(
                  _isKorean ? "계속하기" : "Continue",
                  style: commonbuttonTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 온보딩 5
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

  Future<void> handleContinue() async {
    registrationData['coping_methods'] = _controller.text.trim();
    // Chat with Gemini before onboarding 6
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => GeminiChatPage()),
    );
    if (result != null) {
      registrationData['speaking_style'] = result['speaking_style'];
      registrationData['tone'] = result['tone'];
    }
    // Proceed to onboarding step 6
    Navigator.push(context, MaterialPageRoute(builder: (_) => Onboarding6()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: 100),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kProgressBarRadius),
                    child: LinearProgressIndicator(
                      minHeight: kProgressBarHeight,
                      value: 0.68,
                      color: primaryBlue,
                      backgroundColor: progressGrey,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),

            Text(
              _isKorean
                  ? "공황발작 발생 시 본인만의\n대처 방법이 있으신가요?"
                  : "Do you have your own way\nof coping with panic attacks?",
              style: boldTextStyle,
            ),
            SizedBox(height: 8),
            Text(
              _isKorean
                  ? "대처방법이 없다면 아무것도 적지 않고 계속하기를 눌러주세요"
                  : "If you have no coping methods, leave it blank and press \"continue.\"",
              style: _isKorean ? explainTextStyle : en_explainTextStyle,
            ),
            SizedBox(height: 250),

            Text(
              _isKorean ? "대처방법을 적어주세요" : "Please enter your coping methods.",
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText:
                    _isKorean
                        ? "ex) 다른 생각을 한다"
                        : "ex) Think about something else.",
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
              _isKorean
                  ? "위 예시처럼 문장 형식으로 입력해 주세요\n대처 방법을 자세하고 정확하게 적어주세요"
                  : "Enter in sentence format like the example above.\nDescribe your coping method in detail and accurately.",
              style: explainTextStyle,
            ),

            Spacer(),

            Center(
              child: ElevatedButton(
                style: commonButtonStyle,
                onPressed: handleContinue,
                child: Text(
                  _isKorean ? "계속하기" : "Continue",
                  style: commonbuttonTextStyle,
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// 온보딩 6
class Onboarding6 extends StatelessWidget {
  const Onboarding6({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(24).copyWith(bottom: 100),
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(kProgressBarRadius),
                    child: LinearProgressIndicator(
                      minHeight: kProgressBarHeight,
                      value: 1.0,
                      color: primaryBlue,
                      backgroundColor: progressGrey,
                    ),
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
              _isKorean
                  ? "모든 설정이 끝났어요\n조금만 기다리면\n나만의 방패가 만들어져요"
                  : "All settings are complete.\nYour personal shieldwill\nbe ready soon.",
              style: boldTextStyle,
              textAlign: TextAlign.center,
            ),

            Spacer(),

            ElevatedButton(
              style: commonButtonStyle,
              onPressed: () async {
                // Send collected registration data
                try {
                  final response = await http.post(
                    Uri.parse(
                      'https://panicshield.ngrok.dev/api/auth/register',
                    ),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode(registrationData),
                  );
                  if (response.statusCode == 200) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginPage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isKorean ? '회원가입에 실패했습니다.' : 'Registration failed',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        _isKorean ? '네트워크 오류가 발생했습니다.' : 'Network error',
                      ),
                    ),
                  );
                }
              },
              child: Text(
                _isKorean ? "들어가기" : "Enter",
                style: commonbuttonTextStyle,
              ),
            ),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// Gemini Chat helper and widget
const String geminiEndpoint =
    'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';
const String geminiApiKey = '';

Future<void> handleGeminiChatAndRegister(BuildContext context) async {
  // Navigate to GeminiChatPage and wait for result
  final result = await Navigator.push<Map<String, dynamic>>(
    context,
    MaterialPageRoute(builder: (_) => GeminiChatPage()),
  );
  if (result != null) {
    // Merge speaking_style and tone into registrationData
    registrationData['speaking_style'] = result['speaking_style'];
    registrationData['tone'] = result['tone'];
  }
  // Send collected registration data
  try {
    final response = await http.post(
      Uri.parse('https://panicshield.ngrok.dev/api/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registrationData),
    );
    if (response.statusCode == 200) {
      // Registration successful, navigate to LoginPage
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_isKorean ? '회원가입에 실패했습니다.' : 'Registration failed'),
        ),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_isKorean ? '네트워크 오류가 발생했습니다.' : 'Network error')),
    );
  }
}

class GeminiChatPage extends StatefulWidget {
  @override
  _GeminiChatPageState createState() => _GeminiChatPageState();
}

class _GeminiChatPageState extends State<GeminiChatPage> {
  final List<Map<String, String>> _messages =
      []; // {'role': 'user'|'assistant', 'content': ...}
  final TextEditingController _controller = TextEditingController();
  Timer? _timer;
  bool _classifying = false;
  bool _sending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _messages.add({
          'role': 'system',
          'content':
              _isKorean
                  ? '사용자의 상황에 맞춰 친절히 안내하세요.'
                  : 'You are a helpful assistant guiding the user through onboarding.',
        });
        _messages.add({
          'role': 'assistant',
          'content':
              _isKorean
                  ? '안녕하세요! 지금까지 입력하신 정보를 바탕으로 대화를 시작할게요.'
                  : 'Hello! I will start the conversation based on the information you have provided so far.',
        });
      });
    });
    // Remove automatic timeout: chat will run until user finishes.
    _timer = null;
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final content = _controller.text.trim();
    if (content.isEmpty || _sending) return;
    setState(() {
      _messages.add({'role': 'user', 'content': content});
      _controller.clear();
      _sending = true;
    });
    try {
      final uri = Uri.parse('$geminiEndpoint?key=$geminiApiKey');
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'contents': [
            {
              // messages 순서대로 하나의 parts 리스트에 모두 담는다
              'parts': _messages.map((m) => {'text': m['content']}).toList(),
            },
          ],
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Extract reply text, handling different response formats
        String replyText = '';
        if (data['reply'] != null) {
          replyText = data['reply'].toString();
        } else if (data['choices'] != null &&
            data['choices'][0]?['message'] != null) {
          replyText = data['choices'][0]['message'].toString();
        } else if (data['candidates'] != null &&
            data['candidates'].isNotEmpty &&
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          replyText =
              data['candidates'][0]['content']['parts'][0]['text'].toString();
        }
        print('Gemini API response: $replyText');
        print('Full Gemini API response body: ${response.body}');
        setState(() {
          _messages.add({'role': 'assistant', 'content': replyText});
        });
      } else {
        print('Gemini API error status: ${response.statusCode}');
        setState(() {
          _messages.add({
            'role': 'assistant',
            'content': '[Error from Gemini API: ${response.statusCode}]',
          });
        });
      }
    } catch (e) {
      setState(() {
        _messages.add({'role': 'assistant', 'content': '[Network error]'});
      });
    } finally {
      setState(() {
        _sending = false;
      });
    }
  }

  Future<void> _finishAndClassify() async {
    if (_classifying) return;
    setState(() {
      _classifying = true;
    });
    // Compose a final message to classify the conversation
    final classificationPrompt =
        "Based on the entire conversation so far, what is the user's speaking style and tone? Respond in JSON with keys 'speaking_style' and 'tone'.";
    final allMessages = List<Map<String, String>>.from(_messages)
      ..add({'role': 'user', 'content': classificationPrompt});
    try {
      final response = await http.post(
        Uri.parse(geminiEndpoint),
        headers: {
          'Content-Type': 'application/json',
          'x-goog-api-key': geminiApiKey,
        },
        body: jsonEncode({
          'contents':
              allMessages
                  .map(
                    (m) => {
                      'parts': [
                        {'text': m['content']},
                      ],
                    },
                  )
                  .toList(),
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        String reply =
            data['reply'] ??
            data['choices']?[0]?['message'] ??
            data['choices']?[0]?['text'] ??
            '';
        Map<String, dynamic> parsed = {};
        try {
          // Try to parse JSON from reply
          parsed = jsonDecode(reply);
        } catch (_) {
          // Fallback: try to extract JSON substring
          final match = RegExp(r'\{[\s\S]*\}').firstMatch(reply);
          if (match != null) {
            try {
              parsed = jsonDecode(match.group(0)!);
            } catch (_) {}
          }
        }
        if (parsed.containsKey('speaking_style') &&
            parsed.containsKey('tone')) {
          if (mounted) Navigator.pop(context, parsed);
        } else {
          if (mounted)
            Navigator.pop(context, {'speaking_style': '', 'tone': ''});
        }
      } else {
        if (mounted) Navigator.pop(context, {'speaking_style': '', 'tone': ''});
      }
    } catch (e) {
      if (mounted) Navigator.pop(context, {'speaking_style': '', 'tone': ''});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isKorean ? '대화 스타일 분석' : 'Chat Style Analysis'),
        actions: [
          if (!_classifying)
            TextButton(
              onPressed: _finishAndClassify,
              child: Text(_isKorean ? '분석 완료' : 'Finish & Analyze'),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, idx) {
                final m = _messages[idx];
                final isUser = m['role'] == 'user';
                return Align(
                  alignment:
                      isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color:
                          isUser
                              ? primaryBlue.withOpacity(0.2)
                              : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      m['content'] ?? '',
                      style: TextStyle(
                        color: isUser ? Colors.black : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_classifying)
            Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: CircularProgressIndicator(),
            ),
          if (!_classifying)
            SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        onSubmitted: (_) => _sendMessage(),
                        enabled: !_sending,
                        decoration: InputDecoration(
                          hintText:
                              _isKorean ? '메시지를 입력하세요...' : 'Type a message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton(
                      icon: Icon(Icons.send),
                      onPressed: _sending ? null : _sendMessage,
                      color: primaryBlue,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
