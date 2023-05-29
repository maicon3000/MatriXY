import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CarragamentoCalc extends StatefulWidget {

  CarragamentoCalc({Key? key,}) : super(key: key);

  @override
  State<CarragamentoCalc> createState() => _CarragamentoCalcState();
}

class _CarragamentoCalcState extends State<CarragamentoCalc> {
  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          GestureDetector(
            onTap: () {
              // Impedir que o diálogo seja fechado quando tocar fora da área do conteúdo
            },
            child: Container(
              color: Colors.transparent,
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Lottie.network(
                      'https://assets5.lottiefiles.com/packages/lf20_awP420Zf8l.json',
                      width: 300,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
