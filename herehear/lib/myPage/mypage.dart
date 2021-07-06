import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login/signIn.dart';

class myPage extends StatelessWidget {
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Text(
            '마이페이지',
          ),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
            child: ListView(
              children: <Widget>[
                _profile(),
                _divier(),
                ListTile(
                  title: Text('회원정보 수정'),
                  onTap: () {
                    Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('로그아웃'),
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                ),
                _divier(),

                _info(),
              ],
            )));
  }

  Widget _divier() {
    return Divider(
      color: Colors.grey,
      height: 10,
      thickness: 10,
      indent: 0,
      endIndent: 0,
    );
  }

  Widget _info() {
    return Container(
      padding: const EdgeInsets.fromLTRB(15, 10, 10, 20),
      child: Row(
        children: [
          Container(
              padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
              child: Text(
                '서비스 이용 약관',
                style: TextStyle(color: Colors.grey, fontSize: 10),
              )),
          Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
              child: Text(
                '개인정보 처리방침',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
              )),
        ],
      ),
    );
  }

  Widget _profile() {
    return Column(
      children: [
        //   imageProfile(),
        Container(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text('id'),
        )
      ],
    );
  }


  Widget nameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
              width: 2,
            ),
          ),
          prefixIcon: Icon(
            Icons.person,
            color: Colors.black,
          ),
          labelText: 'Name',
          hintText: 'Input your name'),
    );
  }
}
