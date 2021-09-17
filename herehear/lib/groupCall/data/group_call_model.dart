import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'package:herehear/chatting/util.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';


/// All possible room types
enum MyGroupCallRoomType { channel, direct, group, unsupported }

/// Extension with one [toShortString] method
extension MyRoomTypeToShortString on MyGroupCallRoomType {
  /// Converts enum to the string equal to enum's name
  String toShortString() {
    return toString().split('.').last;
  }
}

/// A class that represents a room where 2 or more participants can chat
@immutable
class GroupCallModel extends Equatable {
  const GroupCallModel({
    required this.users,
    required this.roomInfo,
    this.hostInfo,
    this.title,
    this.notice,
    required this.channelName,
    this.thumbnail,
    this.location,
    this.createdTime,
    required this.type,

    this.listeners,
    this.participants,

    this.reservation,
    this.password,
    this.private
  });

  /// Creates room from a map (decoded JSON).
  GroupCallModel.fromJson(Map<String, dynamic> json)
      : users = (json['users'] as List<Map<String, dynamic>>)
      .map((e) => UserModel.fromJson(e))
      .toList(),
        roomInfo = RoomInfoModel.fromJson(json['roomInfo'] as Map<String, dynamic>),
        hostInfo = UserModel.fromJson(json['hostInfo'] as Map<String, dynamic>),
        title = json['title'] as String,
        notice = json['notice'] as String?,
        channelName = json['channelName'] as String,
        thumbnail = json['thumbnail'] as String?,
        location = json['location'] as String,
        createdTime = json['createdTime'] as DateTime?,
        type = getMyGroupCallTypeFromString(json['type'] as String),
        listeners = json['listeners'].toList(),
        participants = json['participants'].toList(),
  private = json['private'] as bool,
  password = json['password'] as String,
  reservation = json['reservation'] as Timestamp;

  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => {
    'users' : users,
    'roomInfo' : roomInfo,
    'hostInfo' : hostInfo,
        'title': title,
        'notice': notice,
        'channelName': channelName,
        'thumbnail': thumbnail,
        'location': location,
        'createdTime': createdTime,
        'type': type.toShortString(),
        'listeners': listeners,
        'participants': participants,
    'private' : private,
    'reservation' : reservation,
      };

  final RoomInfoModel roomInfo;
  final UserModel? hostInfo; //hostUid, hostNickname, hostProfile

  final String? title;
  final String? notice;
  final String channelName;
  final String? thumbnail;
  final String? location;
  final DateTime? createdTime;
  final List<dynamic>? listeners;
  final List<dynamic>? participants;
  final MyGroupCallRoomType type;
  final Timestamp? reservation;
  final bool? private;
  final String? password;
  final List<UserModel> users; //userNickname, userProfile

  /// Equatable props
  @override
  List<Object?> get props => [

    type,

    //
  ];
}

class GroupCallUserModel extends Equatable {
  GroupCallUserModel({
    this.nickname,
    this.uid,
    this.profileUrl,
    this.isParticipate,
  });

  /// Creates room from a map (decoded JSON).
  GroupCallUserModel.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'] as String,
        uid = json['uid'] as int,
        profileUrl = json['profileUrl'] as String?,
        isParticipate = json['isParticipate'] as bool?;

  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => {
    'nickname': nickname,
    'uid': uid,
    'profileUrl': profileUrl,
    'isParticipate': isParticipate,
  };

  String? nickname;
  int? uid;
  String? profileUrl;
  bool? isParticipate;

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}







// class GroupCallModel {
//   String? hostUid;
//   String? title;
//   String? notice;
//   String? channelName;
//   String? docId;
//   String? image;
//   String? location;
//   DateTime? createdTime;
//   List<dynamic>? currentListener;
//   List<dynamic>? participants;
//
//   GroupCallModel({
//     this.hostUid,
//     this.title,
//     this.notice,
//     this.channelName,
//     this.docId,
//     this.image,
//     this.location,
//     this.createdTime,
//     this.currentListener,
//     this.participants,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'hostUId': this.hostUid,
//       'title': this.title,
//       'notice': this.notice,
//       'channelName': this.channelName,
//       'docId': this.docId,
//       'image': this.image,
//       'location': this.location,
//       'createTIme': this.createdTime,
//       'currentListener': this.currentListener,
//       'participants': this.participants,
//     };
//   }
//
//   GroupCallModel.fromJson(Map<String, dynamic> json, String docId)
//       : hostUid = json['uid'] as String,
//         title = json['title'] as String,
//         notice = json['notice'] as String,
//         channelName = json['title'] as String,
//         docId = json['docId'] as String,
//         image = json['image'] as String,
//         createdTime = json['createdTime'].toDate();
// }


