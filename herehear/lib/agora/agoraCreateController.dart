import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/broadcast/broadcast_model.dart';
import 'package:herehear/groupCall/group_call_model.dart';
import 'package:herehear/login/signIn.dart';
import 'package:get/get.dart';
import 'package:herehear/users/data/user_model.dart';
import 'agoraRepository.dart';

class AgoraCreateController extends GetxController {
  static AgoraCreateController get to => Get.find();

  Rx<BroadcastModel> newBroadcastRoom = BroadcastModel().obs;
  Rx<GroupCallModel> newGroupCallRoom = GroupCallModel().obs;

  Future<void> createBroadcastRoom(
      UserModel userData,
      String title,
      String notice,
      String category,
      String docId,
      List<String> uNickname,
      String location) async {
    if (userData != null) {
      print("==============================");
      print('create broadcast room///////');
      print("==============================");

      print("Uuuuuuuuuuuuuuuuuuuuuuuuuu");
      print(userData.uid);
      print(userData.profile);
      print(title);
      print(notice);
      print(docId);
      print(location);

      newBroadcastRoom.value = BroadcastModel(
        hostUid: userData.uid,
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
        hostProfile: userData.profile,
        userProfile: List<String>.filled(0, '', growable: true),
        hostNickname: userData.nickName,
        userNickname: uNickname,
      );

      print("gooooooooooooooooooooooood");
      await AgoraRepository.BroadcastToFirebase(newBroadcastRoom.value);
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

      await AgoraRepository.GroupCallToFirebase(newGroupCallRoom.value);
    } else {
      print("no user, please sign in");
      Get.to(LoginPage());
    }
  }
}
