import 'package:flutter/material.dart';
import 'package:panicshield/TapPage/ChatTab.dart';
import 'package:panicshield/TapPage/MyPageTab.dart';
import 'package:panicshield/TapPage/HomeTab.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  double selectedIconSize = 50;
  double unselectedIconSize = 40;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, initialIndex: 1, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, top: 10.0),
              child: Image.asset(
                "img/PanicShield_logo.png",
                width: 150,
                fit: BoxFit.contain,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [ChatTab(), HomeTab(), MyPageTab()],
      ),
      bottomNavigationBar: Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 15),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.3),
              offset: Offset(0, 4),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: TabBar(
          controller: _tabController,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: const BoxDecoration(),
          labelStyle: const TextStyle(fontSize: 13),
          dividerColor: Colors.transparent,
          tabs: [
            Tab(
              icon: Image.asset(
                _tabController.index == 0 ? 'img/chat_c.png' : 'img/chat.png',
                width:
                    _tabController.index == 0
                        ? selectedIconSize
                        : unselectedIconSize,
                height:
                    _tabController.index == 0
                        ? selectedIconSize
                        : unselectedIconSize,
                fit: BoxFit.contain,
              ),
            ),
            Tab(
              icon: Image.asset(
                _tabController.index == 1 ? 'img/home_c.png' : 'img/home.png',
                width:
                    _tabController.index == 1
                        ? selectedIconSize
                        : unselectedIconSize,
                height:
                    _tabController.index == 1
                        ? selectedIconSize
                        : unselectedIconSize,
                fit: BoxFit.contain,
              ),
            ),
            Tab(
              icon: Image.asset(
                _tabController.index == 2
                    ? 'img/mypage_c.png'
                    : 'img/mypage.png',
                width:
                    _tabController.index == 2
                        ? selectedIconSize
                        : unselectedIconSize,
                height:
                    _tabController.index == 2
                        ? selectedIconSize
                        : unselectedIconSize,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
