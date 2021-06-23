
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter/material.dart';


class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // 휴대폰 화면 크기 가져오기
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            SizedBox(height: 100,),
            _title(),
            SizedBox(height: 40,),
            _loginField(size, context),
          ],
        ));
  }


  Widget _title() {
    return Text(
      'CLODAY',
      style: TextStyle(
          color: Color(0xFF9D26F4), fontSize: 45, fontWeight: FontWeight.w500),
    );
  }

  Widget _loginField(Size size, BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          _snsLogin(context),
        ],
      ),
    );
  }


  Widget _snsLogin(BuildContext context) {
    return Row(
      children: [
        _googleButton(context),

      ],
    );
  }




  Widget _googleButton(BuildContext context) {
    return IconButton(
      splashColor: Colors.grey,
      onPressed: () async {
        await signInWithGoogle();
        await
      },
      icon: new Image.asset("assets/login/google.png"),
    );
  }


  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }


  void _signInWithGoogle(BuildContext context) async {
    String name;
    String email;
    String imageUrl;

    try {
      print("1");
      final GoogleSignInAccount googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      print("2");
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      print("3");
      final UserCredential authResult =
      await _auth.signInWithCredential(credential);
      final User user = authResult.user;

      print("4");
      assert(!user.isAnonymous);
      assert(await user.getIdToken() != null);

      print("5");
      final User currentUser = await _auth.currentUser;
      assert(user.uid == currentUser.uid);

      print("6");
      assert(user.email != null);
      assert(user.displayName != null);
      assert(user.photoURL != null);

      name = user.displayName;
      email = user.email;
      imageUrl = user.photoURL;

      print("7");
      Navigator.pushNamed(context, '/');
    } catch (err) {
      print("@@@error: $err");
      // final snackBar = SnackBar(content: Text('Error: Login failed.'));
      // Scaffold(
      //   body: Builder(
      //     builder: (context) => Scaffold.of(context).showSnackBar(snackBar);,
      //   ),
      // );

    }
  }
}
