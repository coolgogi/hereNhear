import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/login/signIn.dart';
import 'package:get/get.dart';
import 'agoraRepository.dart';
import 'agoraModel.dart';

class agoraController extends GetxController {
  // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
  static agoraController get to => Get.find();

  Rx<agoraModel> newBroadcastRoom = agoraModel.broadcast().obs;
  Rx<agoraModel> newGroupCallRoom = agoraModel.groupcall().obs;

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
      newBroadcastRoom.value = agoraModel.broadcast(
        hostUid: firebaseUser.uid,
        title: title,
        notice: notice,
        channelName: docId,
        docId: docId,
        image: 'assets/images/mic1.jpg',
        location: location,
        createdTime: DateTime.now(),
        currentListener: List<String>.filled(0, '', growable: true),
        category: category,
        like: 0,
        hostProfile: _data['profile'],
        userProfile: List<String>.filled(0, '', growable: true),
        hostNickname: _data['nickName'],
        userNickname: uNickname,
      );

      await agoraRepository.BroadcastToFirebase(newBroadcastRoom.value);
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
      newGroupCallRoom.value = agoraModel.groupcall(
        hostUid: firebaseUser.uid,
        title: title,
        notice: notice,
        docId: docId,
        image: 'assets/images/mic2.jpg',
        channelName: docId,
        location: location,
        createdTime: DateTime.now(),
      );

      await agoraRepository.GroupCallToFirebase(newGroupCallRoom.value);
    } else {
      print("no user, please sign in");
      Get.to(LoginPage());
    }
  }
}
