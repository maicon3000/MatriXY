import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:matrixy/pages/home_page.dart';

import '../data/database.dart';
import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  //reference the hive box
  final _myBox = Hive.box('mybox');

  HistoricDataBase db = HistoricDataBase();
  //agora nas listas que usamos antes, colocar db. na frente
  @override
  void initState() {
    super.initState();
    _playLottieAnimation();
    navigateBasedOnCache();
  }

  void _playLottieAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );

    _animationController.forward();
  }

  void navigateBasedOnCache() async {
    if (_myBox.get('HISTORICLIST') == null) {
      // O usuário nunca entrou no aplicativo, então redirecione para a tela de login
      await Future.delayed(const Duration(
          milliseconds: 5000)); // Adiciona um pequeno atraso de 500ms
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } else {
      // O usuário já tem dados no cache, então redirecione para a página inicial
      await Future.delayed(const Duration(
          milliseconds: 5000)); // Adiciona um pequeno atraso de 500ms
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(217, 214, 214, 1.0),
      body: Center(
        child: Lottie.network(
          'https://assets3.lottiefiles.com/packages/lf20_qektpg0b.json',
          controller: _animationController,
          onLoaded: (composition) {
            _animationController.duration = composition.duration;
            _animationController.repeat();
            // Use o código acima se quiser repetir a animação continuamente.
            // Se você quiser reproduzi-la apenas uma vez, remova a linha _animationController.repeat();
          },
        ),
      ),
    );
  }
}
