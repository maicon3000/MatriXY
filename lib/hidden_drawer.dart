import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:matrixy/pages/home_page.dart';
import 'package:matrixy/pages/settings_page.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key? key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  final myTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 18,
    color: Colors.white,
    shadows: [
      Shadow(
        offset: Offset(2.0, 2.0),
        blurRadius: 15.0,
        color: Colors.black,
      ),
    ],
  );

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Homepage',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: const Color(0xFF804300),
        ),
        const HomePage(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Settings',
          baseStyle: myTextStyle,
          selectedStyle: myTextStyle,
          colorLineSelected: const Color(0xFF804300),
        ),
        const SettingsPage(),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: const Color(0xFFFFB74D),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
    );
  }
}
