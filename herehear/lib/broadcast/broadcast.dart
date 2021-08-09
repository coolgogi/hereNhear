import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:herehear/bottomNavigationBar/bottom_bar.dart';
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'data/broadcast_model.dart' as types;
import 'data/broadcast_model.dart';
import 'package:herehear/chatting/ChatPage.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/data/user_model.dart';

class BroadCastPage extends GetView<AgoraEventController> {
  // final String channelName;
  //final RoomInfoModel roomInfo;
  // final UserModel userData;
  final ClientRole role;
  final types.BroadcastModel roomData;
  late final agoraController;
  bool muted = false;
  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);

  //Map<String, dynamic> roomData = new Map();

  BroadCastPage(
      {
        //required this.channelName,
     // required this.userData,
      required this.role,
      required this.roomData}) {
    agoraController = Get.put(
        AgoraEventController.broadcast(channelName: roomData.channelName!, role: role));
  }

  BroadCastPage.myBroadcaster(
      { //required this.channelName,
        required this.role,
        // required this.userData,
        required this.roomData}) {
    agoraController = Get.put(
        AgoraEventController.broadcast(channelName: roomData.channelName!, role: role));
  }

  BroadCastPage.myaudience(
      {
        //required this.channelName,
        //required this.userData,
        required this.role,
        //required this.room,
        required this.roomData}) {
    agoraController = Get.put(
        AgoraEventController.broadcast(channelName: roomData.docId!, role: role));
  }
  //
  // BroadCastPage.broadcaster(
  //     { //required this.channelName,
  //     required this.role,
  //     //required this.userData,
  //     required this.roomData}) {
  //   agoraController = Get.put(
  //       AgoraEventController.broadcast(channelName: roomInfo.docId, role: role));
  // }





  // BroadCastPage.audience(
  //     {required this.channelName,
  //     required this.userData,
  //     required this.role,
  //     required this.roomData,
  //     required this.roomInfo}) {
  //   agoraController = Get.put(
  //       AgoraEventController.broadcast(channelName: channelName, role: role));
  // }

  final documentStream = FirebaseFirestore.instance.collection('broadcast');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: documentStream.doc(roomData.docId).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
              return Scaffold(
                appBar: profileAppBar(context),
                body: ChatPage.withData(roomData),
              );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  PreferredSizeWidget profileAppBar(
    BuildContext context,
  ) {
    print(
        '^^^^^^^^^^^^^^^^^^^^^^^^dbData^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6');
    print(roomData.hostInfo!.nickName);
    print(roomData.title);
    print(roomData.hostInfo!.profile);
    return AppBar(
      leading: Card(
        margin: EdgeInsets.only(left: 0.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(roomData.hostInfo!.profile!),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(
        roomData.roomInfo!.title!,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      // backgroundColor: black,
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.add,
            color: Colors.black,
          ),
          onPressed: () {
            inviteDialog(context);
          },
        ),
        IconButton(
          icon: Image.asset(
            'assets/icons/groupBlack.png',
            width: 23.w,
            color: Colors.black,
          ),
          onPressed: () {
            peopleDialog(context);
          },
        ),
        IconButton(
          icon: Image.asset(
            'assets/icons/exit.png',
            width: 23.w,
            color: Colors.red,
          ),
          onPressed: () => _onCallEnd(),
        ),
      ],
    );
  }

  void peopleDialog(BuildContext context) async {
    return Get.defaultDialog(
      title: '참여자',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //hard coding
            Text("참여자 확인 dialog"),
            TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                ),
                onPressed: () => Get.back()),
          ],
        ),
      ),
    );
  }

  void inviteDialog(BuildContext context) async {
    return Get.defaultDialog(
      title: '친구 초대',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //hard coding
            Text("친구 초대 dialog"),
            TextButton(
                child: Text(
                  '확인',
                  style: TextStyle(fontSize: 18.sp, color: Colors.black87),
                ),
                onPressed: () => Get.back()),
          ],
        ),
      ),
    );
  }

  // Future<void> _showMyDialog()
  void _onCallEnd() async {
    if (role == ClientRole.Broadcaster) {
      await changeState(roomData.docId!);
    }
    controller.onClose();
    Get.off(() => BottomBar());
  }

  Future<void> changeState(String docID) async {
    var fields = await FirebaseFirestore.instance
        .collection('broadcast')
        .doc(docID)
        .get();

    FirebaseFirestore.instance
        .collection('closed')
        .doc(docID)
        .set(fields.data()!);
    FirebaseFirestore.instance.collection('broadcast').doc(docID).delete();
  }
}
