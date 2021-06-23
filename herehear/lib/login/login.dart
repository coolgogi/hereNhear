import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // 휴대폰 화면 크기 가져오기
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            _loginField(size, context),
          ],
        ));
  }

  Widget _loginField(Size size, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          _snsLogin(),
        ],
      ),
    );
  }

  Widget _snsLogin() {
    return Row(
      children: [
        _googleButton(),
      ],
    );
  }

  Widget _googleButton() {
    return IconButton(
      splashColor: Colors.grey,
      onPressed: () async {
        await signInWithGoogle();
      },
      icon: new Image.asset("assets/login/google.png"),
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
