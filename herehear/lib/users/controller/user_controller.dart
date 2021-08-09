import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:herehear/users/repository/user_repository.dart';

// 전체 과정 //
// firebaseUser를 받으면 일단 firebaseUser를.uid를 이용해서 이미 데이터베이스에 있는지 없는지 확인
// 없으면 'users' collection을 생성한 뒤에 여기다 해당 정볼르 add 해줘야함.
// 근데 firebase에 업로드를 하기 위해서는 Map 형식이여야 하는데, 여기서 현재 firebase는 User type이므로
// 이를 Map으로 바꿔서 해줘야함.
// 그래서 UserModle을 만든 다음에 toMap함수를 넣어서 이를 Map으로 바꿔준다음에 firebase DB에 업로드

class UserController extends GetxController {
  // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
  static UserController get to => Get.find();
  Rx<UserModel> myProfile = UserModel().obs;
  String? docId;
  String? token;

  // firebase storage에 데이터를 보내는 과정.
  void authStateChanges(User? firebaseUser) async {
    print(
        "this is user======================================================================");
    print(firebaseUser!.uid);
    UserModel? firebaseUserdata =
        await FirebaseUserRepository.findUserByUid(firebaseUser.uid);

    print(firebaseUserdata);

    // firebaseUserData가 null이면 firebase database에 등록이 안된 유저
    if (firebaseUserdata == null) {
      myProfile.value = UserModel(
        id:firebaseUser.uid,
        token: await _token(),
        nickName: 'Nickname',
        profile: 'assets/suhyun.jpg',
        uid: firebaseUser.uid,
        name: firebaseUser.displayName,
        location: '포항시 북구',
      );
      await FirebaseUserRepository.saveUserToFirebase(myProfile.value);
    } else {
      // 기존 firebaseUserdata에 정보가 담겨져 있으니 이를 myProfile에 넣어줘야함.
      myProfile.value = firebaseUserdata;
      //FirebaseUserRepository.updateLoginTime(firebaseUserdata.docId);
    }
  }

  Future<String?> _token() async {
    return FirebaseMessaging.instance.getToken();

  }

  void forAnonymous(User? firebaseUser) async {
    if (firebaseUser!.isAnonymous) {
      print(
          "anonymous+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++");
      myProfile.value = (await FirebaseUserRepository.findUserByUid('Guest'))!;
    }
  }
}
