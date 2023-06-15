import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:matrixy/pages/home_page.dart';
import 'package:matrixy/pages/splash_screen.dart';

import 'matrix/matriz.dart';

void main() async {
  // Registre o adaptador

  await Hive.initFlutter();

  Hive.registerAdapter(MatrizOperationAdapter());
  Hive.registerAdapter(MatrizAdapter());

  //open a box
  var box = await Hive.openBox('mybox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Matrixy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}
