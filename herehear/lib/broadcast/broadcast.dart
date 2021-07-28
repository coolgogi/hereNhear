import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:herehear/chatting/ChatPage.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class BroadCastPage extends StatelessWidget {
  String nickName_broadcaster = '';
  String profile_broadcaster = '';
  late List<dynamic> nickName_audience;
  late List<dynamic> profile_audience;
  final String channelName;
  final String userName;
  final ClientRole role;

  bool muted = false;
  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);
  String host_uid = '';
  late Map<String, dynamic> userData;
  late Map<String, dynamic> dbData = new Map();
  // 안쓰이는 변수
  // final String channelName = Get.arguments;
  static final _users = <int>[];
  final Map<int, String> _allUsers = {};
  late RtcEngine _engine;

  BroadCastPage(
      {required this.channelName, required this.userName, required this.role});

  BroadCastPage.broadcaster(
      {required this.channelName,
      required this.userName,
      required this.role,
      required this.userData}) {
    nickName_broadcaster = userData['nickName'];
    profile_broadcaster = userData['profile'];
  }

  BroadCastPage.audience(
      {required this.channelName,
      required this.userName,
      required this.role,
      required this.dbData}) {
    nickName_broadcaster = dbData['hostNickName'];
    profile_broadcaster = dbData['hostProfile'];
  }

  late final controller =
      Get.put(AgoraEventController.broadcast(channelName, role));

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: profileAppBar(context),
      body: ChatPage.withData(dbData),
    );
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
      // profile_broadcaster =
      // nickName_broadcaster =

    } else if (role == ClientRole.Audience) {
      // profile_audience.add();
      // nickName_audience.add();
    }
  }

  final player = AudioPlayer();

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
        //HARD
        // dbData['title'],
        'title',
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
            Text("참여자 보여주려고 합니다"),
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
      title: '친구초대',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            //hard coding
            Text("초대기능을 넣으려고 합니다."),
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

//어디로 정리할지 고민중
Widget hostCard(BuildContext context, String nickName, String profile) {
  return Row(
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
      SizedBox(height: 4.h),
      Text(
        nickName,
        style: Theme.of(context).textTheme.subtitle1,
      ),
      SizedBox(height: 3.h),
    ],
  );
}
