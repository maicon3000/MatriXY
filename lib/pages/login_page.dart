import 'package:flutter/material.dart';

import 'avatar_selection.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final nameController = TextEditingController();
  String selectedSex = '';

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQueryData = MediaQuery.of(context);
    double screenWidth = mediaQueryData.size.width;
    double screenHeight = mediaQueryData.size.height;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(128, 67, 0, 1),
              Color.fromRGBO(65, 32, 0, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromRGBO(155, 115, 61, 1),
                  Color.fromRGBO(253, 173, 65, 1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: const EdgeInsets.all(16.0),
            height: screenHeight * 0.6,
            width: screenWidth * 0.8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Icon(
                  Icons.android,
                  size: 58.0,
                  color: Colors.white,
                ),
                const Text(
                  'Welcome to MatriXY!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                  ),
                ),
                TextField(
                  controller: nameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    hintText: 'What\'s your name?',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 16.0,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ChoiceChip(
                      label: const Text('Male'),
                      selected: selectedSex == 'M',
                      onSelected: (selected) {
                        setState(() {
                          selectedSex = selected ? 'M' : '';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Female'),
                      selected: selectedSex == 'F',
                      onSelected: (selected) {
                        setState(() {
                          selectedSex = selected ? 'F' : '';
                        });
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Prefer not to say'),
                      selected: selectedSex == 'null',
                      onSelected: (selected) {
                        setState(() {
                          selectedSex = selected ? 'null' : '';
                        });
                      },
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    // Navegar para a tela de seleção do avatar
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AvatarSelectionPage(
                          name: nameController.text,
                          selectedSex: selectedSex,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white.withOpacity(0.2),
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'Select Avatar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
