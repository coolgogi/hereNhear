import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import '../broadcast/data/broadcast_model.dart';
import '../groupCall/data/group_call_model.dart';
import 'package:herehear/login/signIn.dart';
import 'package:get/get.dart';
import 'package:herehear/users/data/user_model.dart';
import 'agoraRepository.dart';
import '../broadcast/data/broadcast_model.dart' as types;


class AgoraCreateController extends GetxController {
  static AgoraCreateController get to => Get.find();

  late Rx<BroadcastModel> newBroadcastRoom;
 // Rx<GroupCallModel> newGroupCallRoom = GroupCallModel().obs;
  late Rx<GroupCallModel> newGroupCallRoom;
  Future<void> createBroadcastRoom(
      UserModel userData,
      String title,
      String notice,
      RoomInfoModel roomInfo,
      List<String> category,
      String channelName,
      List<String> uNickname,
      String location) async {
    if (userData != null) {
      final users = [userData];

      newBroadcastRoom.value = BroadcastModel(
        users: users ,
        roomInfo: roomInfo,
        thumbnail: 'assets/images/mic1.jpg',
        location: location,
        createdTime: DateTime.now(),
        like: 0,
        type: types.MyRoomType.group,
      );

      await AgoraRepository.broadcastToFirebase(newBroadcastRoom.value);
    } else {
      print("no user, please sign in");
      Get.to(LoginPage());
    }
  }

  // Future<void> createGroupCallRoom(User? firebaseUser, String? title,
  //     String? notice, String? docId, String? location) async {
  //   if (firebaseUser != null) {
  //     print("==============================");
  //     print('create groucall room');
  //     print("==============================");
  //
  //     // firebaseUserData가 null이면 firebase database에 등록이 안된 유저
  //     newGroupCallRoom.value = GroupCallModel(
  //       hostInfo: ,
  //       title: title,
  //       notice: notice,
  //       thumbnail: 'assets/images/mic2.jpg',
  //       channelName: docId,
  //       location: location,
  //       createdTime: DateTime.now(), type: MyGroupCallRoomType.group,
  //     );
  //
  //     await AgoraRepository.groupCallToFirebase(newGroupCallRoom.value);
  //   } else {
  //     print("no user, please sign in");
  //     Get.to(LoginPage());
  //   }
  // }
}
