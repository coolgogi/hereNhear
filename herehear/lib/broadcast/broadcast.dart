import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
// import 'package:herehear/appBar/invitation.dart';
import 'package:herehear/etc/delete/user_view.dart';
import 'package:herehear/chatting/ChatPage.dart';
import '../utils/AppID.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';

class AgoraBroadCastController extends GetxController {
  var infoStrings = <String>[].obs;
  var users = <int>[].obs;
  RxBool muted = false.obs;
  var speakingUser = <int?>[].obs;
  late RtcEngine _engine;
  var activeSpeaker = 10.obs;
  final String channelName;
  final ClientRole role;
  AgoraBroadCastController(this.channelName, this.role);

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
  late Map<String, dynamic> userData;

  late Map<String, dynamic> dbData = new Map();

  BroadCastPage(
      {required this.channelName, required this.userName, required this.role}) {
    controller = Get.put(AgoraBroadCastController(channelName, role));
  }
  BroadCastPage.broadcaster(
      {required this.channelName,
      required this.userName,
      required this.role,
      required this.userData}) {
    controller = Get.put(AgoraBroadCastController(channelName, role));
    nickName_broadcaster = userData['nickName'];
    profile_broadcaster = userData['profile'];
  }
  BroadCastPage.audience(
      {required this.channelName,
      required this.userName,
      required this.role,
      required this.dbData}) {
    controller = Get.put(AgoraBroadCastController(channelName, role));
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
      // profile_broadcaster =
      // nickName_broadcaster =

    } else if (role == ClientRole.Audience) {
      // profile_audience.add();
      // nickName_audience.add();
    }
    if (dbData['title'] == '바다 ASMR') {
      await player.setAsset('assets/audio/broadcast/sea.mp3');
      player.play();
    }
    if (dbData['title'] == '포항 문화예술회관') {
      await player.setAsset('assets/audio/broadcast/piano.mp3');
      player.play();
    }
  }

  final player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    getData();
    return Scaffold(
      appBar: profileAppBar(context),
      body: WillPopScope(
        child: ChatPage.withData(dbData),
        onWillPop: () {
          player.pause();
          Get.back();
          return Future(() => false);
        },
      ),
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
        dbData['title'],
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
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(builder: (context) => invite()),
            // );
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
            profileCard(context, '캡틴장', 'assets/gyeongsu.jpg'),
            profileCard(context, 'coolgogi', 'assets/suhyun.jpg'),
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
    if (dbData['title'] == '바다 ASMR') {
      player.pause();
    }
    if (dbData['title'] == '포항 문화예술회관') {
      player.pause();
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

GridView profileCardList(BuildContext context, Map<String, dynamic> data) {
  List<dynamic> profileList = data['userProfile'];
  List<dynamic> nickNameList = data['userNickName'];

  return GridView.builder(
    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5),
    padding: const EdgeInsets.all(8),
    itemCount: profileList.length,
    itemBuilder: (BuildContext context, int i) {
      return profileCard(context, nickNameList[i], profileList[i]);
    },
  );
}
