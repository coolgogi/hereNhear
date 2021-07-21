import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/broadcast/user_view.dart';
import '../utils/AppID.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AgoraEventController extends GetxController {
  var infoStrings = <String>[].obs;
  var users = <int>[].obs;
  RxBool muted = false.obs;
  var speakingUser = <int?>[].obs;
  late RtcEngine _engine;
  var activeSpeaker = 10.obs;
  final String channelName;
  final ClientRole role;
  AgoraEventController(this.channelName, this.role);

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

    await _engine.joinChannel(null, channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    await _engine.enableAudio();
    await _engine.disableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(role);
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
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

class BroadCastPage extends StatelessWidget {
  static final _users = <int>[];

  String nickName_broadcaster = '';
  String profile_broadcaster = '';

  late List<dynamic> nickName_audience;
  late List<dynamic> profile_audience;
  final Map<int, String> _allUsers = {};
  // final String channelName = Get.arguments;
  final String channelName;
  final String userName;
  final ClientRole role;
  late final controller;
  bool muted = false;
  late RtcEngine _engine;
  final buttonStyle = TextStyle(color: Colors.white, fontSize: 15);
  String host_uid = '';

  late Map<String, dynamic> dbData = new Map();

  BroadCastPage(
      {required this.channelName, required this.userName, required this.role}) {
    controller = Get.put(AgoraEventController(channelName, role));
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

  /// Toolbar layout
  Widget _toolbar() {
    return role == ClientRole.Audience
        ? Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: () => _onCallEnd(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '나가기',
                        style: buttonStyle,
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            ))
        : Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RawMaterialButton(
                  onPressed: _onToggleMute,
                  child: Row(
                    children: [
                      Icon(
                        muted ? Icons.mic_off : Icons.mic,
                        color: muted ? Colors.white : Colors.blueAccent,
                        size: 20.0,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      muted
                          ? Text(
                              '음소거 해제',
                              style: buttonStyle,
                            )
                          : Text(
                              '음소거',
                              style: buttonStyle.copyWith(color: Colors.black),
                            )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2.0,
                  fillColor: muted ? Colors.blueAccent : Colors.white,
                  padding: const EdgeInsets.all(15.0),
                ),
                RawMaterialButton(
                  onPressed: () => _onCallEnd(),
                  child: Row(
                    children: [
                      Icon(
                        Icons.call_end,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        '나가기',
                        style: buttonStyle,
                      )
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 2.0,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15.0),
                ),
              ],
            ),
          );
  }

  void _onToggleMute() {
    muted = !muted;
    _engine.muteLocalAudioStream(muted);
  }

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Host',
                  style: Theme.of(context).textTheme.headline6,
                ),
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
                          child: Image.asset(profile_broadcaster),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  nickName_broadcaster,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                SizedBox(height: 4.h),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Audience',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              child: ListView.builder(
                itemCount: _allUsers.length - _users.length,
                itemBuilder: (BuildContext context, int index) {
                  return _users.contains(_allUsers.keys.toList()[index])
                      ? Container()
                      : UserView(
                          role: ClientRole.Audience,
                          userName: _allUsers.values.toList()[index],
                        );
                },
              )),
          _toolbar()
        ],
      )),
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
    // Get.offAll('/');
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
