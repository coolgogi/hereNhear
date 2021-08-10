import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/etc/sh/push1.dart';
import 'package:herehear/users/controller/user_controller.dart';
import '../../login/signIn.dart';

class myPage extends GetView<UserController> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // elevation: 0,
          title: Text('마이페이지',
              style: Theme.of(context).appBarTheme.titleTextStyle),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: ListView(
              children: <Widget>[
                _profile(context),
                _divier(),
                ListTile(
                  title: Text('회원정보 수정'),
                  onTap: () {
                    Get.to(LoginPage());
                  },
                ),
                _divier(),
                ListTile(
                  title: Text('현재 버전 0.0.5'),
                  onTap: () {
                    // Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('실험'),
                  onTap: () {
                    Get.to(FcmFirstDemo());
                  },
                ),
                _divier(),
                ListTile(
                  title: Text('공지사항'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('자주 묻는 질문'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                ListTile(
                  title: Text('문의하기'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                _divier(),
                ListTile(
                  title: Text('로그인 페이지'),
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
                ListTile(
                  title: Text('회원탈퇴'),
                  onTap: () {
                    //Get.to(LoginPage());
                  },
                ),
                _divier(),
                _info(),
              ],
            )));
  }

  Widget _divier() {
    return Divider(
      color: Colors.grey[300],
      height: 10,
      thickness: 7,
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

  Widget imageProfile(BuildContext context) {
    return Center(
        child: Stack(
      children: <Widget>[
        CircleAvatar(
          radius: 60,
          backgroundImage: controller.myProfile.value.profile == null
              ? AssetImage('assets/images/you.png')
              : AssetImage('assets/images/you.png') as ImageProvider,
          //: NetworkImage(_user['profile']) as ImageProvider ,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: InkWell(
              onTap: () {
                //showOptionsDialog(context);
                //showModalBottomSheet(context: context, builder: ((builder) => bottomSheet()));
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.black,
                size: 35,
              )),
        )
      ],
    ));
  }

  Widget _profile(BuildContext context) {
    return Column(
      children: [
        imageProfile(context),
        Container(
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: controller.myProfile.value.uid != null
                ? Text(
                    '${controller.myProfile.value.uid}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                : Text('noUser'))
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
