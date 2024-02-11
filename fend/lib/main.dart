import 'package:fend/pages/bb8.dart';
import 'package:fend/pages/c-3po.dart';
import 'package:fend/pages/character_page.dart';
import 'package:fend/pages/r2-d2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Retro Ed',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CharacterPage(),
    );
  }
}
