import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class TestPage extends StatefulWidget {

  @override
  _TestPage createState() => _TestPage();
}

class _TestPage extends State<TestPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  String name = "";
  String email = "";
  String url = "";

  Future<String> googleSingIn() async {
    final GoogleSignInAccount account = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth = await account.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final authResult = await _auth.signInWithCredential(credential);
    final user = authResult.user;

    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final currentUser = await _auth.currentUser;
    assert(user.uid == currentUser.uid);

    setState(() {
      email = user.email;
      url = user.photoURL;
      name = user.displayName;
    });

    return '구글 로그인 성공: $user';
  }

  void googleSignOut() async {
    await _auth.signOut();
    await googleSignIn.signOut();

    setState(() {
      email = "";
      url = "";
      name = "";
    });

    print("User Sign Out");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            email == ""
                ? Container()
                : Column(
              children: <Widget>[
                Image.network(url),
                Text(name),
                Text(email),
              ],
            ),
            TextButton(
              onPressed: () {
                if (email == "") {
                  googleSingIn();
                } else {
                  googleSignOut();
                }
              },
              child: Container(
                  width: 150,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(Icons.subdirectory_arrow_right),
                      Text(email == "" ? 'Google Login' : "Google Logout")
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

