import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:herehear/appBar/drawer/drawer.dart';
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
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
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
              key: _scaffoldKey,
              endDrawer: DrawerWidget(),
              appBar: profileAppBar(context),
              extendBodyBehindAppBar: true,
              body: ChatPage.withData(roomData),
              // body: ChatPage.withData(roomData),
              backgroundColor: Colors.transparent,
              extendBody: true,
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  // Widget broadcast_body(BuildContext context) {
  //   return Container(
  //     decoration: BoxDecoration(
  //       image: DecorationImage(
  //         fit: BoxFit.cover,
  //         image: AssetImage('assets/suhyun.jpg'),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         Padding(
  //           padding: EdgeInsets.fromLTRB(26.w, 75.h, 24.w, 8.h),
  //           child: Container(
  //             height: 53.h,
  //             decoration: BoxDecoration(
  //               color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
  //               borderRadius: BorderRadius.all(Radius.circular(10.r)),
  //             ),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.only(right: 8.0.w),
  //                   child: Container(
  //                     width: 35.w,
  //                     height: 35.w,
  //                     decoration: BoxDecoration(
  //                       shape: BoxShape.circle,
  //                       image: DecorationImage(
  //                         image: AssetImage('assets/images/me.jpg'),
  //                         fit: BoxFit.cover,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Row(
  //                       children: [
  //                         Text('호스트 NickName', style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.surface)),
  //                         SizedBox(width: 7.w),
  //                         Image.asset('assets/images/rive_red.png', width: 43.5.w, height: 18.w,),
  //                       ],
  //                     ),
  //                     SizedBox(height: 4.h),
  //                     Text('팔로우 숫자', style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.surface)),
  //                   ],
  //                 )
  //               ],
  //             ),
  //           ),
  //         ),
  //         Padding(
  //           padding: EdgeInsets.fromLTRB(26.w, 5.h, 24.w, 8.h),
  //           child: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Container(
  //                 height: 37.h,
  //                 decoration: BoxDecoration(
  //                   color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
  //                   borderRadius: BorderRadius.all(Radius.circular(10.r)),
  //                 ),
  //                 child: Text('방 제목(대화하고 놀아요!)', style: Theme.of(context).textTheme.headline4!.copyWith(color: Theme.of(context).colorScheme.surface)),
  //               ),
  //               Container(
  //                 height: 37.h,
  //                 decoration: BoxDecoration(
  //                   color: Theme.of(context).colorScheme.onBackground.withOpacity(0.4),
  //                   borderRadius: BorderRadius.all(Radius.circular(10.r)),
  //                 ),
  //                 child: Text('공지 사항 목록', style: Theme.of(context).textTheme.headline6!.copyWith(color: Theme.of(context).colorScheme.surface)),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Expanded(
  //           child: Container(
  //             color: Colors.transparent,
  //               child: ChatPage.withData(roomData)),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  PreferredSizeWidget profileAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(45.0.h),
      child: AppBar(
        leading: IconButton(
            onPressed: () {
              _onCallEnd();
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Container(
          margin: const EdgeInsets.all(8.0),
          padding: EdgeInsets.fromLTRB(7.w, 2.w, 7.w, 3.w),
          decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.background),
              borderRadius: BorderRadius.circular(12.r)),
          child:
              Text(" $timer_title ", style: Theme.of(context).textTheme.subtitle1!.copyWith(color: Theme.of(context).colorScheme.background)),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: null,
              icon: Image.asset('assets/icons/bell_white.png', height: 18.0.h)),
          IconButton(
              onPressed: () => _scaffoldKey.currentState!.openEndDrawer(),
              icon: Image.asset('assets/icons/more_white.png', height: 17.0.h)),
        ],
        // toolbarOpacity: 0.0,
        // bottomOpacity: 0.0,
        // flexibleSpace:
      ),
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
