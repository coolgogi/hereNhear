import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/AppID.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;

class AgoraEventController extends GetxController {
  var infoStrings = <String>[].obs;
  var users = <int>[].obs;
  RxBool muted = false.obs;
  var speakingUser = <int?>[].obs;
  var participants = <int?>[].obs;
  late RtcEngine _engine;
  var activeSpeaker = 10.obs;

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
    await _engine.joinChannel(null, GroupCallPage().channelName, null, 0);
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
        infoStrings.add(info);
      },
      leaveChannel: (stats) {
        infoStrings.add('onLeaveChannel');
        users.clear();
      },
      userJoined: (uid, elapsed) {
        final info = 'userJoined: $uid';
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
        // print('!!!!!!!!!!!!!!: ${speakingUser.value.asMap().entries.}');

        print(
            '*************************: ${speakingUser.isEmpty ? null : speakingUser}');
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

  void onToggleMute() {
    muted.value = !muted.value;
    _engine.muteLocalAudioStream(muted.value);
  }

  void onSwitchCamera() {
    _engine.switchCamera();
  }
}

class GroupCallPage extends StatelessWidget {
  final String channelName = Get.arguments;

  final controller = Get.put(AgoraEventController());

  /// Toolbar layout
  Widget _toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Obx(
            () => RawMaterialButton(
              onPressed: controller.onToggleMute,
              child: Icon(
                controller.muted.value ? Icons.mic_off : Icons.mic,
                color:
                    controller.muted.value ? Colors.white : Colors.blueAccent,
                size: 20.0,
              ),
              shape: CircleBorder(),
              elevation: 2.0,
              fillColor:
                  controller.muted.value ? Colors.blueAccent : Colors.white,
              padding: const EdgeInsets.all(12.0),
            ),
          ),
          RawMaterialButton(
            onPressed: () => _onCallEnd(),
            child: Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
          ),
          RawMaterialButton(
            onPressed: controller.onSwitchCamera,
            child: Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
            shape: CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Agora Group Video Calling'),
      ),
      backgroundColor: Colors.black,
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
            child: Column(
              children: [
                Text('참여', style: Theme.of(context).textTheme.headline2,),
                Center(
                  child: Stack(
                    children: <Widget>[
                      Obx(() => _viewRows()),
                      _toolbar(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text('관전', style: Theme.of(context).textTheme.headline2,),
          Row(
            children: <Widget>[
              Obx(() => _viewRows()),
            ],
          )
        ],
      ),
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
  List<Widget> _getRenderViews() {
    final List<Widget> list = [];
    // if(controller.activeSpeaker == 0) {
    //   list.add(Container( decoration: BoxDecoration(
    //     border: Border.all(
    //       color: Colors.lightGreen,
    //       width: 2,
    //     ),
    //   ),
    //       child: Image(image: AssetImage('assets/images/me.jpg'), width: 150, height: 150, )));
    // }
    // else list.add(Image(image: AssetImage('assets/images/me.jpg'), width: 150, height: 150,));
    //
    // controller.users.forEach((int uid) {
    //   print('!!!!!!: $uid');
    //     if(uid == controller.activeSpeaker) {
    //       list.add(Container( decoration: BoxDecoration(
    //         border: Border.all(
    //           color: Colors.lightGreen,
    //           width: 2,
    //         ),
    //       ),
    //           child: Image(image: AssetImage('assets/images/you.png'), width: 150, height: 150, )));
    //     }
    //     else
    //       list.add(Image(image: AssetImage('assets/images/you.png'), width: 150, height: 150,));
    //   // list.add(RtcRemoteView.SurfaceView(uid: uid));
    // });

    // bool flag1 = false;
    // for(int i = 0; i < controller.speakingUser.length; i++) {
    //   if(controller.speakingUser[i] == 0) {
    //     list.add(Container( decoration: BoxDecoration(
    //       border: Border.all(
    //         color: Colors.lightGreen,
    //         width: 2,
    //       ),
    //     ),
    //         child: Image(image: AssetImage('assets/images/me.jpg'), width: 150, height: 150, )));
    //     flag1 = true;
    //     break;
    //   }
    // }
    // if(flag1 != true)
    //   list.add(Image(image: AssetImage('assets/images/me.jpg'), width: 150, height: 150,));
    // //프로필 이미지 받아오는 거 어떻게 할지 고민중이었음. 비디오 기능 없애고 오디오 기능으로ㅇㅇ
    list.add(Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Image(
        image: AssetImage('assets/images/me.jpg'),
        width: 150,
        height: 150,
      ),
    ));

    controller.users.forEach((int uid) {
      print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
      bool flag = false;
      for (int i = 0; i < controller.speakingUser.length; i++) {
        if (uid == controller.speakingUser[i]) {
          list.add(Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.lightGreen,
                  width: 2,
                ),
              ),
              child: Image(
                image: AssetImage('assets/images/you.png'),
                width: 150,
                height: 150,
              )));
          flag = true;
          break;
        }
      }
      if (flag != true)
        list.add(Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Image(
            image: AssetImage('assets/images/you.png'),
            width: 150,
            height: 150,
          ),
        ));
      // list.add(RtcRemoteView.SurfaceView(uid: uid));
    });
    return list;
  }

  List<Widget> _getParticipantsImageList() {
    final List<Widget> list = [];

    list.add(Padding(
      padding: EdgeInsets.all(16.0.h),
      child: Container(
        child: CircleAvatar(
          radius: 35,
          backgroundImage: AssetImage('assets/images/me.jpg'),
        ),
      ),
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

    controller.users.forEach((int uid) {
      print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
      bool flag = false;
      for (int i = 0; i < controller.speakingUser.length; i++) {
        if (uid == controller.speakingUser[i]) {
          list.add(Padding(
            padding: EdgeInsets.all(16.0.h),
            child: Container(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.lightGreen,
                child: CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage('assets/images/you.png'),
                ),
              ),
            ),
          )
              // Container(
              // decoration: BoxDecoration(
              //   shape: BoxShape.circle,
              //   border: Border.all(
              //     color: Colors.lightGreen,
              //     width: 2,
              //   ),
              // ),
              // child: Image(
              //   image: AssetImage('assets/images/you.png'),
              //   width: 150,
              //   height: 150,
              // ))
      );
          flag = true;
          break;
        }
      }
      if (flag != true)
        list.add(Padding(
          padding: EdgeInsets.all(16.0.h),
          child: Container(
            child: CircleAvatar(
              radius: 35,
              backgroundImage: AssetImage('assets/images/you.png'),
            ),
          ),
        ));
      // list.add(RtcRemoteView.SurfaceView(uid: uid));
    });
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

  // Widget _viewWatcher() {
  //   return
  // }

  /// Video layout wrapper
  Widget _viewRows() {
    // final views = _getRenderViews();
    var views = _getParticipantsImageList();
    switch (views.length) {
      case 1:
        return Container(
            child: Column(
          children: <Widget>[_videoView(views[0])],
        ));
      case 2:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow([views[0]]),
            _expandedVideoRow([views[1]])
            // views[0],
            // views[1]
          ],
        ));
      case 3:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 3))
          ],
        ));
      case 4:
        return Container(
            child: Column(
          children: <Widget>[
            _expandedVideoRow(views.sublist(0, 2)),
            _expandedVideoRow(views.sublist(2, 4))
          ],
        ));
      default:
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
