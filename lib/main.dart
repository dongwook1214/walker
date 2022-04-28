import 'package:flutter/material.dart';
import 'src/loginPage.dart';
import 'src/pallete.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'walker',
      theme: ThemeData(
        primarySwatch: Palette.duck,
      ),
      home: MyLoginPage(),
    );
  }
}
