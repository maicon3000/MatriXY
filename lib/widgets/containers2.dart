import 'package:flutter/material.dart';

class MyContainer2 extends StatefulWidget {
  const MyContainer2({super.key, required this.text2});
  final String? text2;

  @override
  State<MyContainer2> createState() => _MyContainerState();
}

class _MyContainerState extends State<MyContainer2> {
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
          topLeft: Radius.circular(15),
          topRight: Radius.circular(30),
        ),
      ),
      width: MediaQuery.of(context).size.width * 0.5,
      height: MediaQuery.of(context).size.height * 0.24,
      child: Text(widget.text2 ?? 'Y'),
    );
  }
}
