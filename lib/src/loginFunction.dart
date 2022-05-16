import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'map.dart';

Future loginFunction(id, password, context) async {
  try {
    final UserCredential result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: id, password: password);
    final user = result.user;

    if (user == null) {
      return;
    }
    _onLoginSuccess(context);
  } on FirebaseAuthException catch (e) {
    print(e);
    if (e.code == 'user-not-found') {
      _showSnackBar(context, "올바른 아이디를 입력하세요.");
      print("user-not-found");
    } else if (e.code == 'wrong-password') {
      _showSnackBar(context, "올바른 비밀번호를 입력하세요.");
      print('wrong-password');
    } else if (e.code == 'invalid-email') {
      _showSnackBar(context, "올바른 아이디 형식을 입력하세요.");
      print('invalid-email');
    }
  }
}

void _onLoginSuccess(context) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => Map()),
  );
}

void _showSnackBar(context, String message) {
  final snackBar = SnackBar(content: Text(message));
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
