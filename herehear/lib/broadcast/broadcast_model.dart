import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:herehear/chatting/util.dart';
import 'package:herehear/users/data/user_model.dart';
import 'package:meta/meta.dart';


/// All possible room types
enum MyRoomType { channel, direct, group, unsupported }

/// Extension with one [toShortString] method
extension MyRoomTypeToShortString on MyRoomType {
  /// Converts enum to the string equal to enum's name
  String toShortString() {
    return toString().split('.').last;
  }
}

/// A class that represents a room where 2 or more participants can chat
@immutable
class BroadcastModel extends Equatable {
  /// Creates a [BroadcastModel]
  const BroadcastModel({
    this.createdAt,
    required this.id,
    this.imageUrl,
    this.lastMessages,
    this.metadata,
    this.name,
    required this.type,
    this.updatedAt,
    this.users,
    //
    this.hostInfo,
    this.title,
    this.notice,
    this.channelName,
    this.docId,
    this.thumbnail,
    this.location,
    this.createdTime,
    this.roomCategory,
    this.like,



  });

  // final UserModel hostInfo; //hostUid, hostNickname, hostProfile
  // final String title;
  // final String? notice;
  // final String channelName;
  // final String docId;
  // String? thumbnail; //image
  // final String location;
  // final DateTime createdTime;
  // final List<String?>? roomCategory; //category
  // int? like;
  // final List<UserModel>? users; //userNickname, userProfile

  /// Creates room from a map (decoded JSON).
  BroadcastModel.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'] as int?,
        id = json['id'] as String,
        imageUrl = json['imageUrl'] as String?,
        lastMessages = (json['lastMessages'] as List<Map<String, dynamic>>?)
            ?.map((e) => Message.fromJson(e))
            .toList(),
        metadata = json['metadata'] as Map<String, dynamic>?,
        name = json['name'] as String?,
        type = getMyRoomTypeFromString(json['type'] as String),
        updatedAt = json['updatedAt'] as int?,

//
        hostInfo = UserModel.fromJson(json['hostInfo'] as Map<String, dynamic>),
        title = json['title'] as String,
        notice = json['notice'] as String,
        channelName = json['channelName'] as String,
        docId = json['docId'] as String,
        thumbnail =json['thumbnail'] as String,
        location = json['location'] as String,
        createdTime = json['createdTime'].toDate(),
        roomCategory = json['roomCategory'].toList(),
        like =json['like'] as int,
        users = (json['users'] as List<Map<String, dynamic>>)
            .map((e) => UserModel.fromJson(e))
            .toList()
  ;



  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'id': id,
    'imageUrl': imageUrl,
    'lastMessages': lastMessages?.map((e) => e.toJson()).toList(),
    'metadata': metadata,
    'name': name,
    'type': type.toShortString(),
    'updatedAt': updatedAt,
    //
    'hostInfo' : hostInfo!.toJson(),
    'title' : title,
    'notice' : notice,
    'channelName': channelName,
    'docId' : docId,
    'thumbnail' : thumbnail,
    'location' : location,
    'createdTime' : createdTime,
    'roomCategory' : roomCategory,
    'like' : like,
    'users' : users?.map((e)=>e.toJson()).toList(),


  };

  /// Creates a copy of the room with an updated data.
  /// [imageUrl], [name] and [updatedAt] with null values will nullify existing values
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  /// [type] and [users] with null values will be overwritten by previous values.
  // BroadcastModel copyWith({
  //   String? imageUrl,
  //   Map<String, dynamic>? metadata,
  //   String? name,
  //   RoomType? type,
  //   int? updatedAt,
  //   List<User>? users,
  // }) {
  //   return BroadcastModel(
  //     id: id,
  //     imageUrl: imageUrl,
  //     lastMessages: lastMessages,
  //     metadata: metadata == null
  //         ? null
  //         : {
  //       ...this.metadata ?? {},
  //       ...metadata,
  //     },
  //     name: name,
  //     type: type ?? this.type,
  //     updatedAt: updatedAt,
  //     users: users ?? this.users,
  //   );
  // }

  /// Equatable props
  @override
  List<Object?> get props => [
    createdAt,
    id,
    imageUrl,
    lastMessages,
    metadata,
    name,
    type,
    updatedAt,
    //
  ];


  final UserModel? hostInfo; //hostUid, hostNickname, hostProfile
  final String? title;
  final String? notice;
  final String? channelName;
  final String? docId;
  final String? thumbnail; //image
  final String? location;
  final DateTime? createdTime;
  final List<String>? roomCategory; //category
  final int? like;
  final List<UserModel>? users; //userNickname, userProfile


  /// Created room timestamp, in ms
  final int? createdAt;

  /// Room's unique ID
  final String id;

  /// Room's image. In case of the [RoomType.direct] - avatar of the second person,
  /// otherwise a custom image [RoomType.group].
  final String? imageUrl;

  /// List of last messages this room has received
  final List<Message>? lastMessages;

  /// [RoomType]
  final MyRoomType type;

  /// Additional custom metadata or attributes related to the room
  final Map<String, dynamic>? metadata;

  /// Room's name. In case of the [RoomType.direct] - name of the second person,
  /// otherwise a custom name [RoomType.group].
  final String? name;

  /// Updated room timestamp, in ms
  final int? updatedAt;

/// List of users which are in the room
}























// class BroadcastModel {
//   //using both side.
//   String? hostUid;
//   String? title;
//   String? notice;
//   String? channelName;
//   String? docId;
//   String? image;
//   String? location;
//   DateTime? createdTime;
//   List<String>? currentListener;
//   //only broadcast
//   String? category;
//   int? like;
//   String? hostProfile;
//   List<String>? userProfile;
//   String? hostNickname;
//   List<String>? userNickname;
//
//   BroadcastModel({
//     this.hostUid,
//     this.title,
//     this.notice,
//     this.channelName,
//     this.docId,
//     this.image,
//     this.location,
//     this.createdTime,
//     this.currentListener,
//     //only broadcast
//     this.category,
//     this.like,
//     this.hostProfile,
//     this.userProfile,
//     this.hostNickname,
//     this.userNickname,
//   });
//
//   // UserModel을 map으로 바꿔주는 함수.
//   Map<String, dynamic> toMap() {
//     return {
//       'hostUid': this.hostUid,
//       'title': this.title,
//       'notice': this.notice,
//       'channelName': this.channelName,
//       'docId': this.docId,
//       'image': this.image,
//       'location': this.location,
//       'createdTime': this.createdTime,
//       'currentListener': this.currentListener,
//       //only broadcast
//       'category': this.category,
//       'like': this.like,
//       'hostProfile': this.hostProfile,
//       'hostNickName': this.hostNickname,
//       'userProfile': this.userProfile,
//       'userNickName': this.userNickname,
//     };
//   }
//
//   BroadcastModel.fromJson(Map<String, dynamic> json, String hostUid)
//       : hostUid = json['uid'] as String,
//         title = json['title'] as String,
//         notice = json['notice'] as String,
//         channelName = json['channelName'] as String,
//         docId = json['docId'] as String,
//         image = json['image'] as String,
//         createdTime = json['createdTime'].toDate(),
//         //only broadcast
//         category = json['category'] as String,
//         like = json['like'] as int;
// }
//
// // Map<String, dynamic> toJson() => {
// //   'hostUid': createdAt,
// //   'title': id,
// //   'notice': imageUrl,
// //   'channelName': lastMessages?.map((e) => e.toJson()).toList(),
// //   'docId': metadata,
// //   'image': name,
// //   'createdTime': type.toShortString(),
// //   'category': updatedAt,
// //   'like': users.map((e) => e.toJson()).toList(),
// // };
//