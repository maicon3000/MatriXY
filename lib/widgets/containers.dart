import 'package:flutter/material.dart';

class MyContainer extends StatefulWidget {
  const MyContainer({super.key, required this.text1});
  final String? text1;

  @override
  State<MyContainer> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(155, 115, 61, 1),
            Color.fromRGBO(253, 173, 65, 1),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(15),
          bottomLeft: Radius.circular(15),
          topLeft: Radius.circular(30),
          topRight: Radius.circular(15),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.24,
      child: Text(widget.text1 ?? 'X'),
    );
  }
}
