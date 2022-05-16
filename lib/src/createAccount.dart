import 'package:flutter/material.dart';
import 'createAccountFunction.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passWordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                color: Colors.white, width: size.width, height: size.height),
            SafeArea(
              child: Column(
                children: [
                  Container(height: size.height * 0.01),
                  _walkerCreateAccountTitle(),
                  Stack(
                    children: [
                      _racoonImage(size),
                      _idPsTextField(size),
                    ],
                  ),
                  Container(height: size.height * 0.03),
                  _createAccountButton(size)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _walkerCreateAccountTitle() {
    return Column(
      children: [
        const Text(
          "walker",
          style: TextStyle(fontSize: 60, fontFamily: 'shadowsIntoLight'),
        ),
        const Text(
          "create new account!",
          style: TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  Widget _racoonImage(size) {
    return Center(
      child: Image.asset(
        "asset/image/racoon.gif",
        width: size.height * 0.4,
        height: size.height * 0.4,
      ),
    );
  }

  Widget _idPsTextField(size) {
    return Column(
      children: [
        Container(height: size.height * 0.37),
        Padding(
          padding:
              EdgeInsets.only(left: size.width * 0.1, right: size.width * 0.1),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(width: 0.5, color: Colors.black54),
            ),
            elevation: 6,
            child: Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                child: Column(
                  children: [
                    TextFormField(
                      cursorColor: Colors.amber,
                      controller: _idController,
                      decoration: const InputDecoration(
                        icon: Icon(Icons.account_circle),
                        labelText: "Email",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '이메일 입력해주세요';
                        } else {
                          return null;
                        }
                      },
                    ),
                    TextFormField(
                      cursorColor: Colors.amber,
                      obscureText: true,
                      controller: _passWordController,
                      decoration: const InputDecoration(
                          icon: Icon(Icons.vpn_key), labelText: 'PassWord'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '비밀번호 입력해주세요';
                        } else {
                          return null;
                        }
                      },
                    ),
                    Container(height: 10)
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _createAccountButton(size) {
    return SizedBox(
      width: size.width * 0.6,
      height: size.height * 0.07,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            signUpWithEmail(
                _idController.text, _passWordController.text, context);
          }
        },
        child: const Text("Create!"),
        style: ElevatedButton.styleFrom(
          side: const BorderSide(width: 0.5, color: Colors.black54),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          primary: Colors.yellow,
          onPrimary: Colors.black,
        ),
      ),
    );
  }
}
