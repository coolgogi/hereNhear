import 'dart:core';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/groupCall/data/group_call_model.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:herehear/utils/AppID.dart';
import 'dart:math';

// final int GROUPCALL = 0;
// final int BROADCAST = 1;
//
// final int GROUPCALL = 0;
// final int BROADCAST = 1;

enum RoomType { groupcall, broadcast }

/// Extension with one [toShortString] method
extension RoomTypeToShortString on RoomType {
  /// Converts enum to the string equal to enum's name
  String toShortString() {
    return toString().split('.').last;
  }
}

class AgoraEventController extends GetxController {
  CollectionReference groupCall =  FirebaseFirestore.instance.collection('groupcall');
  var infoStrings = <String>[].obs;
  var users = <int>[].obs;
  var listener = <UserModel>[].obs;
  var followers = <UserModel>[].obs;
  RxBool muted = false.obs;
  RxBool isChatActive = false.obs;
  var speakingUser = <int?>[].obs;
  var participants = <int>[].obs;
  late RtcEngine _engine;
  var activeSpeaker = 10.obs;
  int currentUid = 0;
  RxBool isParticipate = false.obs;
  RxBool NotGoOutRoom = false.obs;
  final String channelName;
  final ClientRole role;
  late final String type;

  RxBool noticeActive = true.obs;

  //////// temp data for distinguish each users//////////
  int randomNumber = Random().nextInt(5);
  int memberCount = 1;

  List<String> profileList = [
    'assets/images/me.jpg',
    'assets/images/it2.jpg',
    'assets/images/it.jpg',
    'assets/images/you.png',
    'assets/images/she2.jpeg'
  ];
  var profile = <String>[].obs;

  GroupCallUserModel userExample = GroupCallUserModel();
///////////////////////////////////////////////////////

  RxList<Widget> participantsList = <Widget>[].obs;
  RxList<Widget> listenersList = <Widget>[].obs;


  RxBool isGroupCallPageNow = false.obs;

  AgoraEventController.groupcall(
      {required this.channelName, required this.role}) {
    this.type = RoomType.groupcall.toShortString();
  }

  AgoraEventController.broadcast(
      {required this.channelName, required this.role}) {
    this.type = RoomType.broadcast.toShortString();
  }
  //

  @override
  void onInit() {
    super.onInit();
    initialize();
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
    await _engine.enableAudioVolumeIndication(200, 3, true);
    // await getToken();
    // print('token : $token');
    // await _engine?.joinChannel(token, widget.channelName, null, 0);
    await _engine.joinChannel(null, channelName, null, 0);
  }

  /// Create agora sdk instance and initialize
  Future<void> _initAgoraRtcEngine() async {
    _engine = await RtcEngine.create(appID);
    await _engine.disableVideo();
    await _engine.enableAudio();
    await _engine.enableLocalAudio(false);

    if (this.type == 'broadcast') {
      await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
      await _engine.setClientRole(role);
    }
  }

  /// Add agora event handlers
  void _addAgoraEventHandlers() {
    _engine.setEventHandler(RtcEngineEventHandler(
      error: (code) {
        final info = 'onError: $code';
        infoStrings.add(info);
      },
      joinChannelSuccess: (channel, uid, elapsed) {
        print('채널 들어감!!!!!!!!!!!!!!!!!!!!!!!!!!! ');
        final info = 'onJoinChannel: $channel, uid: $uid';
        currentUid = uid;
        print('currentUid???: ${currentUid}');
        infoStrings.add(info);
        NotGoOutRoom.value = true;
        print('infoStrings: ${infoStrings}');
        print('infoStrings: ${infoStrings}');

        followers.add(UserController.to.myProfile.value);
        users.add(uid);
UserController.to.myProfile.value.roomUid = uid;
        userExample.uid = currentUid;
      },
      leaveChannel: (stats) {
        infoStrings.add('onLeaveChannel');
        users.clear();
        participants.clear();
        NotGoOutRoom.value = false;
      },
      userJoined: (uid, elapsed) {

        print('사용자!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! ');
        final info = 'userJoined: $uid';
        infoStrings.add(info);
        users.add(uid);
      },
      userOffline: (uid, reason) {
        final info = 'userOffline: $uid , reason: $reason';
        infoStrings.add(info);
        users.remove(uid);
        participants.remove(uid);
      },
      firstRemoteVideoFrame: (uid, width, height, elapsed) {
        final info = 'firstRemoteVideoFrame: $uid';
        infoStrings.add(info);
      },
      activeSpeaker: (uid) {
        speakingUser.clear();
        speakingUser.add(uid);
        // speakingUser
        //     .addAll(speakers.obs.map((element) => element.uid).toList());
        print('current Speakers: ${speakingUser.value}');
      },
      audioVolumeIndication: (speakers, totalVolume) {
        speakingUser.clear();
        speakingUser
            .addAll(speakers.obs.map((element) => element.uid).toList());
        print('current Speakers: ${speakingUser.length}, uid: ${speakingUser.first}, ${speakingUser.value.last}');
      },
    ));
  }

  Future<void> moveWatcherToParticipant(String channelName) async {
    print('currentUid???: ${currentUid}');
    users.removeWhere((element) => element == currentUid);
    DocumentReference groupCallDoc =  groupCall.doc(channelName);
    groupCallDoc.update({'participants':FieldValue.arrayUnion([UserController.to.myProfile.value.uid])});
    groupCallDoc.update({
      'listeners': FieldValue.arrayRemove([UserController.to.myProfile.value.uid])
    });
    isParticipate.value = true;

    await _engine.enableLocalAudio(true);
    print('대화 참가자 수: ${participants.length}');
  }

  void onToggleMute() {
    muted.value = !muted.value;
    _engine.muteLocalAudioStream(muted.value);
  }

  void onToggleChatButton() {
    isChatActive.value = !isChatActive.value;
  }

  void onSwitchCamera() {
    _engine.switchCamera();
  }
}