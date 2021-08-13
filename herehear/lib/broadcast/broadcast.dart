import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:herehear/bottomNavigationBar/bottom_bar.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'data/broadcast_model.dart' as types;
import 'package:herehear/chatting/chat.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BroadCastPage extends GetView<AgoraEventController> {
  final ClientRole role;
  final types.BroadcastModel roomData;
  late final agoraController;
  bool muted = false;
  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);
  final fireStore = FirebaseFirestore.instance;
  //Map<String, dynamic> roomData = new Map();
  //나중에 db에서 가져올 예정
  String timer_title = 'timer';
  BroadCastPage(
      {
      //required this.channelName,
      // required this.userData,
      required this.role,
      required this.roomData}) {
    agoraController = Get.put(AgoraEventController.broadcast(
        channelName: roomData.channelName, role: role));
  }

  BroadCastPage.broadcaster(
      { //required this.channelName,
      required this.role,
      // required this.userData,
      required this.roomData}) {
    agoraController = Get.put(AgoraEventController.broadcast(
        channelName: roomData.channelName, role: role));
  }

  BroadCastPage.audience({required this.role, required this.roomData}) {
    agoraController = Get.put(AgoraEventController.broadcast(
        channelName: roomData.channelName, role: role));
  }

  final documentStream = FirebaseFirestore.instance.collection('broadcast');

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
        stream: documentStream.doc(roomData.channelName).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: profileAppBar(context),
              extendBodyBehindAppBar: true,
              body: broadcast_body(context),
              // body: ChatPage.withData(roomData),
              // body: Image.asset('assets/suhyun.jpg'),

              backgroundColor: Colors.white,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget broadcast_body(BuildContext context) {
    return Stack(children: [
      ChatPage.withData(roomData),
      Image.asset('assets/suhyun.jpg'),
    ]);
  }

  PreferredSizeWidget profileAppBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
          onPressed: () {
            _onCallEnd();
          },
          icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            borderRadius: BorderRadius.circular(45)),
        child:
            Text("$timer_title", style: Theme.of(context).textTheme.subtitle1),
      ),
      actions: <Widget>[
        IconButton(
            icon: Image.asset('assets/icons/bell.png'),
            onPressed: () {
              // inviteDialog(context);
            },
            padding: EdgeInsets.all(0)),
        IconButton(
            icon: Image.asset('assets/icons/more_grey.png',
                width: 24.0, height: 24.0),
            iconSize: 4.0,
            onPressed: () {
              // inviteDialog(context);
            },
            padding: EdgeInsets.all(0)),
      ],
      toolbarOpacity: 0.0,
      bottomOpacity: 0.0,
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
    if (roomData.hostInfo!.uid == UserController.to.myProfile.value.uid) {
      await changeState(roomData.channelName);
    }
    await fireStore.collection('broadcast').doc(roomData.channelName).update({
      'userIds':
          FieldValue.arrayRemove([UserController.to.myProfile.value.uid]),
    });
    controller.onClose();
    Get.back();
  }

  Future<void> changeState(String channelName) async {
    var fields = await fireStore.collection('broadcast').doc(channelName).get();

    fireStore.collection('closed').doc(channelName).set(fields.data()!);
    FirebaseFirestore.instance
        .collection('broadcast')
        .doc(channelName)
        .delete();
  }
}
