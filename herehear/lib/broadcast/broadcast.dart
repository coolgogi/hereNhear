import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:herehear/chatting/ChatPage.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BroadCastPage extends StatelessWidget {
  String nickName_broadcaster = '';
  String profile_broadcaster = '';
  late List<dynamic> nickName_audience;
  late List<dynamic> profile_audience;
  final String channelName;
  final String userName;
  final ClientRole role;
  late final controller;
  bool muted = false;
  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);
  String host_uid = '';
  late Map<String, dynamic> userData;
  late Map<String, dynamic> dbData = new Map();

  //unused variable
  // final String channelName = Get.arguments;
  late RtcEngine _engine;
  final Map<int, String> _allUsers = {};
  static final _users = <int>[];

  BroadCastPage(
      {required this.channelName, required this.userName, required this.role}) {
    controller = Get.put(
        AgoraEventController.broadcast(channelName: channelName, role: role));
  }
  BroadCastPage.broadcaster(
      {required this.channelName,
      required this.userName,
      required this.role,
      required this.userData}) {
    controller = Get.put(
        AgoraEventController.broadcast(channelName: channelName, role: role));
    nickName_broadcaster = userData['nickName'];
    profile_broadcaster = userData['profile'];
  }
  BroadCastPage.audience(
      {required this.channelName,
      required this.userName,
      required this.role,
      required this.dbData}) {
    controller = Get.put(
        AgoraEventController.broadcast(channelName: channelName, role: role));
    nickName_broadcaster = dbData['hostNickName'];
    profile_broadcaster = dbData['hostProfile'];
  }

  void getData() async {
    var temp = await FirebaseFirestore.instance
        .collection('broadcast')
        .doc(channelName)
        .get();

    dbData = temp.data()!;
    host_uid = dbData['hostUid'];
    nickName_broadcaster = dbData['hostNickName'];
    profile_broadcaster = dbData['hostProfile'];
    nickName_audience = dbData['userNickName'];
    profile_audience = dbData['userProfile'];
    print("===========dbData===========");
    print(dbData['hostUid']);
    print(dbData['hostProfile']);
    print("============================");
    if (role == ClientRole.Broadcaster) {
      print("==========notice===========");
      print("Broadcaster");
      print("===========================");
    } else if (role == ClientRole.Audience) {
      print("==========notice===========");
      print("Audience");
      print("===========================");
    }
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: profileAppBar(context),
      body: ChatPage.withData(dbData),
    );
  }

  PreferredSizeWidget profileAppBar(BuildContext context) {
    return AppBar(
      // leading: hostCard(context, nickName_broadcaster, profile_broadcaster)
      leading: Card(
        margin: EdgeInsets.only(left: 0.0.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 30,
              height: 30,
              child: Image.asset(profile_broadcaster),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      title: Text(
        // dbData['title'],
        'hard coding',
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
      await changeState(channelName);
    }
    controller.onClose();
    Get.back();
    Get.back();
    Get.back();
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

//어디로 가야할지
Widget profileCard(BuildContext context, String nickName, String profile) {
  return Column(
    children: [
      Container(
        width: 35.0.w,
        height: 35.0.h,
        child: Card(
          margin: EdgeInsets.only(left: 0.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 30,
                height: 30,
                child: Image.asset(profile),
              ),
            ],
          ),
        ),
      ),
      SizedBox(height: 5.h),
      Text(
        nickName,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      SizedBox(height: 4.h),
    ],
  );
}
