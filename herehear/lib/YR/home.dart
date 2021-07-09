import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/myPage/mypage.dart';


class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance
          .authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        // snapshot.data를 GetX Controller에 보냄
        ProfileController.to.authStateChanges(snapshot.data);
        if (!snapshot.hasData) {
          return LoginPage(); //data가 없으면 로그인으로
        } else {
          return myPage(); // data가 있으면 MainPage로
        }
      },
    );
  }
}

class ProfileController extends GetxController {
  // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
  static ProfileController get to => Get.find();
  Map<String, dynamic> firebaseUserdata = {};
  String? docId;

  Future? findUserByUid(String uid) async {
    // users collection에 있는 모든 user들을 users에 담음.
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // users collection에서 현재 firebaseUser.uid인 user만 가져와서 이를 data에 옮김
    QuerySnapshot data = await users.where('uid', isEqualTo: uid).get();
    // 여기서 data.size가 0이면 결국 같은 uid를 가진 user가 없다는 뜻.
    if (data.size == 0) {
      return null;
    } else {
      // 같은 uid를 가진 여러명의 data중에서 첫 번째것만 필요. 그리고 return은 Map<String, dynamic>으로 받음
      // 결과적으로 userData가 현재 로그인된 userData이므로 이를 전체 front에서 공유하고 firebase에 업로드 하면됨.
     final userData = data.docs[0].data();
      docId = data.docs[0].id;
      return userData;
    }
  }

  Future<Map<String, dynamic>> fromMap(User firebaseUser, String uid) async {
    firebaseUserdata = {
      'uid': uid,
      'name': firebaseUser.displayName,
      'email': firebaseUser.email,
      'created_time': DateTime.now().toIso8601String(),
      'last_login_time': DateTime.now().toIso8601String(),
    };
    return firebaseUserdata;
  }

  void saveUserToFirebase(User firebaseUser) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // firebase의 users collection에 data를 추가하는 것.
    users.add(await fromMap(firebaseUser, firebaseUser.uid));
  }

  void updateLoginTime() {
    // userdata가 있다면 마지막 로그인 시간을 업데이트 해줘야함.
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .doc(docId)
        .update({'last_login_time': DateTime.now().toIso8601String()});
  }

  // firebase storage에 데이터를 보내는 과정.
  void authStateChanges(User? firebaseUser) async {
    if (firebaseUser != null) {
      firebaseUserdata = await findUserByUid(firebaseUser.uid);
      // firebaseUserData가 null이면 firebase database에 등록이 안된 유저
      if (firebaseUserdata == null) {
        saveUserToFirebase(firebaseUser);
      } else {
        updateLoginTime();
      }
    }
  }
}