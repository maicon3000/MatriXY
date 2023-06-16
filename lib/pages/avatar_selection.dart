import 'package:flutter/material.dart';
import '../data/database.dart';
import 'home_page.dart';

class AvatarSelectionPage extends StatelessWidget {
  final String name;
  final String selectedSex;
  const AvatarSelectionPage(
      {super.key, required this.name, required this.selectedSex});

  @override
  Widget build(BuildContext context) {
    List avatarList = [
      Image.asset('lib/assets/boy1.png'),
      Image.asset('lib/assets/boy2.png'),
      Image.asset('lib/assets/girl1.png'),
      Image.asset('lib/assets/girl2.png'),
      Image.asset('lib/assets/monster.png'),
      Image.asset('lib/assets/robot.png'),
    ];

    List images = [
      'lib/assets/boy1.png',
      'lib/assets/boy2.png',
      'lib/assets/girl1.png',
      'lib/assets/girl2.png',
      'lib/assets/monster.png',
      'lib/assets/robot.png',
    ];

    void goToHomePage(imag) {
      HistoricDataBase db = HistoricDataBase();

      User user = User(name: name, selectedSex: selectedSex, images: imag);

      db.userData.add(user);
      db.updateDataBaseUser(); // Salvar dados do usuário no Hive
      db.loadDataUser(); // Carregar dados do usuário do Hive

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(
            user: user,
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: avatarList.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        GestureDetector(
                          onTap: () => goToHomePage(images[index]),
                          child: SizedBox(
                            height: MediaQuery.of(context).size.width * 0.13,
                            child: avatarList[index],
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.width * 0.05,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
