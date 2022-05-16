import 'package:flutter/material.dart';
import 'src/loginPage.dart';
import 'src/pallete.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MaterialApp(
            title: 'walker',
            theme: ThemeData(
              primarySwatch: Palette.duck,
            ),
            home: MyLoginPage(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
