import 'dart:core';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:get/get.dart';
import 'package:herehear/utils/AppID.dart';

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
  var infoStrings = <String>[].obs;
  var users = <int>[].obs;
  RxBool muted = false.obs;
  RxBool isChatActive = false.obs;
  var speakingUser = <int?>[].obs;
  var participants = <int>[].obs;
  late RtcEngine _engine;
  var activeSpeaker = 10.obs;
  int currentUid = 0;
  RxBool isParticipate = false.obs;
  final String channelName;
  final ClientRole role;
  late final String type;

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
      },
    ));
  }

  void moveWatcherToParticipant() {
    users.removeWhere((element) => element == currentUid);
    participants.add(currentUid);
    isParticipate.value = true;
    print('?!?!?: ${participants.length}');
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
