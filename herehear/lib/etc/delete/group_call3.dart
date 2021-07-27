import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../utils/AppID.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgoraEventController extends GetxController {
  var infoStrings = <String>[].obs;
  var users = <int>[].obs;
  RxBool muted = false.obs;
  var speakingUser = <int?>[].obs;
  var participants = <int>[].obs;
  late RtcEngine _engine;
  var activeSpeaker = 10.obs;
  int currentUid = 0;
  RxBool is_participate = false.obs;

  @override
  void onInit() {
    // called immediately after the widget is allocated memory
    initialize();
    super.onInit();
  }

  @override
  void onClose() {
    // clear users
    users.clear();
    // destroy sdk
    _engine.leaveChannel().obs;
    _engine.destroy().obs;
    super.onClose();
  }

  Future<void> initialize() async {
    if (appID.isEmpty) {
      infoStrings.add(
        'APP_ID missing, please provide your APP_ID in settings.dart',
      );
      infoStrings.add('Agora Engine is not starting');
      return;
    }
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();
    // await _engine.enableWebSdkInteroperability(true);
    await _engine.enableAudioVolumeIndication(250, 2, true);
    print("ggggggggggggggggggggggggggggg");
    // await getToken();
    // print('token : $token');
    // await _engine?.joinChannel(token, widget.channelName, null, 0);
    await _engine.joinChannel(null, GroupCallPage2().channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    // await _engine?.enableVideo();
    await _engine.enableAudio();
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    print('################################################################');
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        final info = 'onError: $code';
        infoStrings.add(info);
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        final info = 'onJoinChannel: $channel, uid: $uid';
        currentUid = uid;
        infoStrings.add(info);
      },
      leaveChannel: (stats) {
        infoStrings.add('onLeaveChannel');
        users.clear();
        participants.clear();
      },
      userJoined: (uid, elapsed) {
        final info = 'userJoined: $uid';
        currentUid = uid;
        infoStrings.add(info);
        users.add(uid);
      },
      userOffline: (uid, reason) {
        final info = 'userOffline: $uid , reason: $reason';
        infoStrings.add(info);
        users.remove(uid);
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        final info = 'firstRemoteVideoFrame: $uid';
        infoStrings.add(info);
      },
      audioVolumeIndication: (speakers, totalVolume) {
        speakingUser.clear();
        speakingUser
            .addAll(speakers.obs.map((element) => element.uid).toList());
        // print(
        //     '*************************: ${speakingUser.isEmpty ? null : speakingUser}');
      },
      // activeSpeaker: (uid) {
      //   activeSpeaker = uid.obs;
      // }
      // tokenPrivilegeWillExpire: (token) async {
      //   await getToken();
      //   await _engine?.renewToken(token);
      // },
    ));
  }

  void move_watcher_to_participant() {
    users.removeWhere((element) => element == currentUid);
    participants.add(currentUid);
    is_participate = true.obs;
    print('?!?!?: ${participants.length}');
  }

  void onToggleMute() {
    muted.value = !muted.value;
    _engine.muteLocalAudioStream(muted.value);
  }

  void onSwitchCamera() {
    _engine.switchCamera();
  }
}

class GroupCallPage2 extends StatefulWidget {
  final String channelName = Get.arguments;
  @override
  _GroupCallPage2State createState() => _GroupCallPage2State();
}

class _GroupCallPage2State extends State<GroupCallPage2> {
  final String channelName = Get.arguments;

  bool already_join = false;

  final controller = Get.put(AgoraEventController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.add),
          color: Colors.black,
          onPressed: null,
        ),
        backgroundColor: Colors.black,
        title: Center(
          child: Text(
            'Here&Hear',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Noto Sans CJK kr',
              fontWeight: FontWeight.w900,
              fontSize: 18.sp,
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 10.0.h, right: 8.0.w),
            child: Column(
              children: <Widget>[
                Icon(Icons.people),
                Text(
                  '999+',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Image.asset(
              'assets/icons/exit.png',
              width: 23.w,
              color: Colors.white,
            ),
            onPressed: () => _onCallEnd(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 288.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 30.0.h),
                    child: Text(
                      '참여',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 19.sp,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(() => _viewRows(_getParticipantsImageList())),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0.h, left: 16.0.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '관전',
                  style: Theme.of(context).textTheme.headline2,
                ),
                Row(
                  children: <Widget>[
                    Obx(() => _viewRows(_getWatcherImageList())),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomBar(context),
    );
  }

  /// Helper function to get list of native views
  // List<Widget> _getRenderViews() {
  //   final List<StatefulWidget> list = [];
  //   list.add(RtcLocalView.SurfaceView());
  //   _users.forEach((int uid) {
  //     list.add(RtcRemoteView.SurfaceView(uid: uid));
  //   });
  //   return list;
  // }
  List<Widget> _getParticipantsImageList() {
    final List<Widget> list = [];

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/me.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0, top: 8.0),
          child: Text(
            '낚시쟁이',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/it.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 6.0, top: 8.0),
          child: Text(
            '포항장첸',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/dog.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 9.0, top: 8.0),
          child: Text(
            '댕댕이',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/he.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0, top: 8.0),
          child: Text(
            '공부벌레',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ],
    ));
    // list.add(Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
    //       child: Container(
    //         child: CircleAvatar(
    //           radius: 30,
    //           backgroundImage: AssetImage('assets/images/cat.jpg'),
    //         ),
    //       ),
    //     ),
    //     Padding(
    //       padding: EdgeInsets.only(left: 7.0, top: 8.0),
    //       child: Text('이시구기', style: TextStyle(color: Colors.white),),
    //     ),
    //   ],
    // ));

    if (controller.is_participate.value) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
            child: Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/you.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 14.0, top: 8.0),
            child: Text(
              'USER',
              style: TextStyle(
                  color: controller.is_participate.value
                      ? Colors.white
                      : Color(0xFF618051)),
            ),
          ),
        ],
      ));
    }

    //   controller.participants.forEach((int uid) {
    //     // print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
    //     bool flag = false;
    //     for (int i = 0; i < controller.speakingUser.length; i++) {
    //       if (uid == controller.speakingUser[i]) {
    //         list.add(Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Padding(
    //               padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
    //               child: Container(
    //                   child: CircleAvatar(
    //                     radius: 30,
    //                     backgroundColor: Colors.lightGreen,
    //                     child: CircleAvatar(
    //                       radius: 30,
    //                       backgroundImage: AssetImage('assets/images/you.png'),
    //                     ),
    //                   ),
    //               ),
    //             ),
    //             Padding(
    //               padding: EdgeInsets.only(left: 9.0, top: 8.0),
    //               child: Text('ME', style: TextStyle(color: Colors.white),),
    //             ),
    //           ],
    //         ));
    //         flag = true;
    //         break;
    //       }
    //     }
    //       if (flag != true)
    //   list.add(Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Padding(
    //         padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
    //         child: Container(
    //           child: CircleAvatar(
    //             radius: 30,
    //             backgroundImage: AssetImage('assets/images/you.png'),
    //           ),
    //         ),
    //       ),
    //       Padding(
    //         padding: EdgeInsets.only(left: 7.0, top: 8.0),
    //         child: Text('ME', style: TextStyle(color: Colors.white),),
    //       ),
    //     ],
    //   ));
    //   // list.add(RtcRemoteView.SurfaceView(uid: uid));
    // }

    // );

    return list;
  }

  List<Widget> _getWatcherImageList() {
    final List<Widget> list = [];

    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/me.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0, top: 8.0),
          child: Text(
            '짱구형아',
            style: TextStyle(color: Color(0xFF618051)),
          ),
        ),
      ],
    )
        //     Container(
        //   decoration: BoxDecoration(
        //     shape: BoxShape.circle,
        //     image: DecorationImage(
        //       fit: BoxFit.fill,
        //       image: AssetImage('assets/images/me.jpg'),
        //     ),
        //   ),
        // )
        );
    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/she2.jpeg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0, top: 8.0),
          child: Text(
            '명품내놔',
            style: TextStyle(color: Color(0xFF618051)),
          ),
        ),
      ],
    ));
    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/you2.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0, top: 8.0),
          child: Text(
            '바나나킥',
            style: TextStyle(color: Color(0xFF618051)),
          ),
        ),
      ],
    ));
    list.add(Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
          child: Container(
            child: CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage('assets/images/it2.jpg'),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 7.0, top: 8.0),
          child: Text(
            '샌드위치',
            style: TextStyle(color: Color(0xFF618051)),
          ),
        ),
      ],
    ));
    if (controller.is_participate.value == false) {
      list.add(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
            child: Container(
              child: CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/you.png'),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 7.0, top: 8.0),
            child: Text(
              'USER',
              style: TextStyle(
                  color: controller.is_participate.value
                      ? Colors.white
                      : Color(0xFF618051)),
            ),
          ),
        ],
      ));
      print(controller.users.obs);
    }

    // controller.users.forEach((int uid) {
    //   print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
    //   bool flag = false;
    //   for (int i = 0; i < controller.speakingUser.length; i++) {
    //     if (uid == controller.speakingUser[i]) {
    //       list.add(Padding(
    //         padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
    //         child: Container(
    //           child: CircleAvatar(
    //             radius: 40,
    //             backgroundColor: Colors.lightGreen,
    //             child: CircleAvatar(
    //               radius: 30,
    //               backgroundImage: AssetImage('assets/images/you.png'),
    //             ),
    //           ),
    //         ),
    //       )
    //         // Container(
    //         // decoration: BoxDecoration(
    //         //   shape: BoxShape.circle,
    //         //   border: Border.all(
    //         //     color: Colors.lightGreen,
    //         //     width: 2,
    //         //   ),
    //         // ),
    //         // child: Image(
    //         //   image: AssetImage('assets/images/you.png'),
    //         //   width: 150,
    //         //   height: 150,
    //         // ))
    //       );
    //       flag = true;
    //       break;
    //     }
    //   }
    //   if (flag != true)
    //     list.add(Padding(
    //       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
    //       child: Container(
    //         child: CircleAvatar(
    //           radius: 30,
    //           backgroundImage: AssetImage('assets/images/you.png'),
    //         ),
    //       ),
    //     ));
    //   // list.add(RtcRemoteView.SurfaceView(uid: uid));
    // });
    return list;
  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(
        child: Center(
      child: view,
    ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      children: wrappedViews,
    );
  }

  Widget bottomBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.0.w, 10.0.w, 10.0.w, 10.0.w),
            child: InkWell(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.chat, color: Colors.black),
              ),
              onTap: null,
            ),
          ),
          Expanded(
            child: Container(
              height: 50.h,
            ),
          ),
          Obx(() => Padding(
                padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
                child: InkWell(
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: controller.muted.value
                        ? Theme.of(context).colorScheme.primary
                        : Colors.white,
                    child: Icon(
                      controller.muted.value ? Icons.mic_off : Icons.mic,
                      color: !already_join
                          ? Colors.grey
                          : controller.muted.value
                              ? Colors.white
                              : Colors.black,
                      size: 30,
                    ),
                  ),
                  onTap: (() {
                    if (already_join == true) controller.onToggleMute();
                  }),
                ),
              )),
          Padding(
            padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
            child: InkWell(
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.pan_tool_outlined,
                  color: Colors.black,
                  size: 28,
                ),
              ),
              onTap: (() {
                setState(() {
                  if (already_join == false)
                    controller.move_watcher_to_participant();

                  already_join = true;
                });
              }),
            ),
          )
        ],
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows(List<Widget> userImageList) {
    // final views = _getRenderViews();
    var views = userImageList;
    print('asdfasdf: $views');
    if (views.length == 1) {
      return Container(
          child: Column(
        children: <Widget>[_videoView(views[0])],
      ));
    } else if (views.length <= 5) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, views.length)),
        ],
      ));
    } else if (views.length <= 10) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, 5)),
          _expandedVideoRow(views.sublist(5, views.length - 1))
        ],
      ));
    } else if (views.length <= 15) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, 5)),
          _expandedVideoRow(views.sublist(5, 10)),
          _expandedVideoRow(views.sublist(15, views.length - 1))
        ],
      ));
    } else if (views.length <= 20) {
      return Container(
          child: Column(
        children: <Widget>[
          _expandedVideoRow(views.sublist(0, 5)),
          _expandedVideoRow(views.sublist(5, 10)),
          _expandedVideoRow(views.sublist(10, 15)),
          _expandedVideoRow(views.sublist(15, views.length - 1))
        ],
      ));
    }
    return Container();
  }

  void _onCallEnd() {
    controller.onClose();
    Get.back();
    Get.back();
    Get.back();
  }
}
