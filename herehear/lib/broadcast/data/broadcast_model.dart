import 'package:equatable/equatable.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
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
   BroadcastModel({
    required this.roomInfo,
    this.createdAt,
    this.imageUrl,
    this.lastMessages,
    this.metadata,
    this.name,
    required this.type,
    this.updatedAt,
    required this.users,
    this.thumbnail,
    this.location,
    this.createdTime,
    this.roomCategory,
    required this.like,
    this.likedPeople,



  });

  /// Creates room from a map (decoded JSON).
  BroadcastModel.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'] as int?,
        imageUrl = json['imageUrl'] as String?,
        lastMessages = (json['lastMessages'] as List<Map<String, dynamic>>?)
            ?.map((e) => Message.fromJson(e))
            .toList(),
        metadata = json['metadata'] as Map<String, dynamic>?,
        name = json['name'] as String?,
        type = getMyRoomTypeFromString(json['type'] as String),
        updatedAt = json['updatedAt'] as int?,

//
        roomInfo = RoomInfoModel.fromJson(json['roomInfo'] as Map<String, dynamic>),
        thumbnail =json['thumbnail'] as String,
        location = json['location'] as String,
        createdTime = json['createdTime'].toDate(),
        roomCategory = json['roomCategory'].toList(),
        like =json['like'] as int,
  likedPeople =json['liePeople'].toList,
        users = (json['users'] as List<Map<String, dynamic>>)
            .map((e) => UserModel.fromJson(e))
            .toList()
  ;



  /// Converts room to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => {
    'createdAt': createdAt,
    'imageUrl': imageUrl,
    'lastMessages': lastMessages?.map((e) => e.toJson()).toList(),
    'metadata': metadata,
    'name': name,
    'type': type.toShortString(),
    'updatedAt': updatedAt,
    //
    'roomInfo' : roomInfo.toJson(),
    'thumbnail' : thumbnail,
    'location' : location,
    'createdTime' : createdTime,
    'roomCategory' : roomCategory,
    'like' : like,
    'likePeople': likedPeople,
    'users' : users.map((e)=>e.toJson()).toList(),


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
    imageUrl,
    lastMessages,
    metadata,
    name,
    type,
    updatedAt,
    //
  ];

  final RoomInfoModel roomInfo;

  final String? thumbnail; //image
  final String? location;
  final DateTime? createdTime;
  final List<dynamic>? roomCategory; //category
   int like = 0;
  final List<UserModel> users; //userNickname, userProfile
  List<String>? likedPeople;


  /// Created room timestamp, in ms


  final int? createdAt;

  /// Room's unique ID

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





















