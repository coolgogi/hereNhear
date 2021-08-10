import 'package:equatable/equatable.dart';
import 'package:herehear/chatting/util.dart';
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
  /// Creates a [GroupCallModel]
  ///   final String? hostUid;
  //   final String? title;
  //   final String? notice;
  //   final String? channelName;
  //   final String? docId;
  //   final String? image;
  //   final String? location;
  //   final DateTime? createdTime;
  //   final List<dynamic>? currentListener;
  //   final List<dynamic>? participants;
  const GroupCallModel({
    this.hostUid,
    this.title,
    this.notice,
    this.channelName,
    this.docId,
    this.thumbnail,
    this.location,
    this.createdTime,
    required this.type,
    this.currentListener,
    this.participants,
  });

  /// Creates room from a map (decoded JSON).
  GroupCallModel.fromJson(Map<String, dynamic> json)
      : hostUid = json['hostUid'] as String,
        title = json['title'] as String,
        notice = json['notice'] as String?,
        channelName = json['channelName'] as String?,
        docId = json['docId'] as String?,
        thumbnail = json['thumbnail'] as String?,
        location = json['location'] as String,
        createdTime = json['createdTime'] as DateTime?,
        type = getMyGroupCallTypeFromString(json['type'] as String),
        currentListener = json['currentListener'].toList(),
        participants = json['participants'].toList();

  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => {
        'hostUid': hostUid,
        'title': title,
        'notice': notice,
        'channelName': channelName,
        'docId': docId,
        'thumbnail': thumbnail,
        'location': location,
        'createdTime': createdTime,
        'type': type.toShortString(),
        'currentListener': currentListener,
        'participants': participants,
      };

  final String? hostUid;
  final String? title;
  final String? notice;
  final String? channelName;
  final String? docId;
  final String? thumbnail;
  final String? location;
  final DateTime? createdTime;
  final List<dynamic>? currentListener;
  final List<dynamic>? participants;
  final MyGroupCallRoomType type;

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
