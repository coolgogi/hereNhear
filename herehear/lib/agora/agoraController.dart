import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/broadcast/repository/broadcast_repository.dart';
import 'package:herehear/groupCall/data/group_call_model.dart';
import 'package:herehear/broadcast/data/broadcast_model.dart';
import 'package:herehear/groupCall/repository/group_call_repository.dart';
import 'package:herehear/login/signIn.dart';
import 'package:get/get.dart';

// 전체 과정 //
// firebaseUser를 받으면 일단 firebaseUser를.uid를 이용해서 이미 데이터베이스에 있는지 없는지 확인
// 없으면 'users' collection을 생성한 뒤에 여기다 해당 정볼르 add 해줘야함.
// 근데 firebase에 업로드를 하기 위해서는 Map 형식이여야 하는데, 여기서 현재 firebase는 User type이므로
// 이를 Map으로 바꿔서 해줘야함.
// 그래서 UserModel을 만든 다음에 toMap함수를 넣어서 이를 Map으로 바꿔준다음에 firebase DB에 업로드

class agoraController extends GetxController {
  // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
  static agoraController get to => Get.find();

  Rx<BroadcastModel> newStreamingRoom = BroadcastModel().obs;
  Rx<GroupCallModel> newGroupCallRoom = GroupCallModel().obs;

  Future<void> createBroadcastRoom(
      User? firebaseUser,
      String title,
      String notice,
      String category,
      String docId,
      dynamic _data,
      List<String> uNickname,
      String location) async {
    if (firebaseUser != null) {
      print("==============================");
      print('create broadcast room');
      print("==============================");
      newStreamingRoom.value = BroadcastModel(
        hostUid: firebaseUser.uid,
        title: title,
        notice: notice,
        category: category,
        docId: docId,
        image: 'assets/images/mic1.jpg',
        like: 0,
        channelName: docId,
        createdTime: DateTime.now(),
        currentListener: List<String>.filled(0, '', growable: true),
        hostProfile: _data['profile'],
        userProfile: List<String>.filled(0, '', growable: true),
        hostNickname: _data['nickName'],
        userNickname: uNickname,
        location: location,
      );

      await BroadcastRepository.BroadcastToFirebase(newStreamingRoom.value);
    } else {
      print("no user, please sign in");
      Get.to(LoginPage());
    }
  }

  Future<void> createGroupCallRoom(User? firebaseUser, String? title,
      String? notice, String? docId, String? location) async {
    if (firebaseUser != null) {
      print("==============================");
      print('create groucall room');
      print("==============================");
      // firebaseUserData가 null이면 firebase database에 등록이 안된 유저
      newGroupCallRoom.value = GroupCallModel(
        hostUid: firebaseUser.uid,
        title: title,
        notice: notice,
        docId: docId,
        image: 'assets/images/mic2.jpg',
        channelName: docId,
        location: location,
        createdTime: DateTime.now(),
      );

      await GroupCallRepository.GroupCallToFirebase(newGroupCallRoom.value);
    } else {
      print("no user, please sign in");
      Get.to(LoginPage());
    }
  }
}
