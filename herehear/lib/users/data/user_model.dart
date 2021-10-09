import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:herehear/chatting/util.dart' show getMyRoleFromString;
//import 'util.dart' show getMyRoleFromString;

/// All possible roles user can have.
enum MyRole { admin, agent, moderator, user }

/// Extension with one [toShortString] method
extension MyRoleToShortString on MyRole {
  /// Converts enum to the string equal to enum's name
  String toShortString() {
    return toString().split('.').last;
  }
}

/// A class that represents user.
@immutable
class UserModel extends Equatable {
  /// Creates a user.
  UserModel(
      {this.createdAt,
      this.id,
      this.imageUrl,
      this.lastSeen,
      this.metadata,
      this.role,
      this.updatedAt,
      //
        this.roomUid,
      this.platform,
      this.token,
      this.uid,
      this.nickName,
      this.name,
      this.location,
      this.profile,
      this.subscribe});

  /// Creates user from a map (decoded JSON).
  UserModel.fromJson(Map<String, dynamic> json)
      : createdAt = json['createdAt'] as int?,
        id = json['id'] as String,
        imageUrl = json['imageUrl'] as String?,
        lastSeen = json['lastSeen'] as int?,
        metadata = json['metadata'] as Map<String, dynamic>?,
        role = getMyRoleFromString(json['role'] as String?),
        updatedAt = json['updatedAt'] as int?,
        //
  roomUid = json['roomUid'] as int?,
        platform = json['platform'] as String,
        token = json['token'] as String,
        uid = json['uid'] as String,
        name = json['name'] as String,
        nickName = json['nickName'] as String,
        profile = json['profile'] as String,
        subscribe = json['subscribe'] as List,
        location = json['location'] as String;

  /// Converts user to the map representation, encodable to JSON.
  Map<String, dynamic> toJson() => {
        'createdAt': createdAt,

        'id': id,
        'imageUrl': imageUrl,

        'lastSeen': lastSeen,
        'metadata': metadata,
        'role': role?.toShortString(),
        'updatedAt': updatedAt,
        //
    'roomUid' : this.roomUid,
        'platform': this.platform,
        'token': this.token,
        'uid': this.uid,
        'name': this.name,
        'location': this.location,
        'nickName': this.nickName,
        'profile': this.profile,
        'subscribe': this.subscribe,
      };

  /// Creates a copy of the user with an updated data.
  /// [firstName], [imageUrl], [lastName], [lastSeen], [role] and [updatedAt]
  /// with null values will nullify existing values.
  /// [metadata] with null value will nullify existing metadata, otherwise
  /// both metadatas will be merged into one Map, where keys from a passed
  /// metadata will overwite keys from the previous one.
  UserModel copyWith({
    String? firstName,
    String? imageUrl,
    String? lastName,
    int? lastSeen,
    Map<String, dynamic>? metadata,
    MyRole? role,
    int? updatedAt,
  }) {
    return UserModel(
      id: id,
      imageUrl: imageUrl,
      lastSeen: lastSeen,
      metadata: metadata == null
          ? null
          : {
              ...this.metadata ?? {},
              ...metadata,
            },
      role: role,
      updatedAt: updatedAt,
    );
  }

  /// Equatable props
  @override
  List<Object?> get props =>
      [createdAt, id, imageUrl, lastSeen, metadata, role, updatedAt];

  //   String? token;
//   String? uid;
//   String? docId;
//   String? id;
//   String? password;
//   String? nickName;
//   String? name;
//   String? location;
//   int? age;
//   String? profile;
//   String? number;
//   List<dynamic>? subscribe;

  int? roomUid;
  String? token;
  final String? uid;
  String? nickName;
  final String? name;
  final String? location;
  final String? profile;
  final List<dynamic>? subscribe;

  String? platform;

  /// Created user timestamp, in ms
  final int? createdAt;

  /// First name of the user

  /// Unique ID of the user
  final String? id;

  /// Remote image URL representing user's avatar
  final String? imageUrl;

  /// Last name of the user

  /// Timestamp when user was last visible, in ms
  final int? lastSeen;

  /// Additional custom metadata or attributes related to the user
  final Map<String, dynamic>? metadata;

  /// User [Role]
  final MyRole? role;

  /// Updated user timestamp, in ms
  final int? updatedAt;
}

//
//
// class UserModel {
//   String? token;
//   String? uid;
//   String? docId;
//   String? id;
//   String? password;
//   String? nickName;
//   String? name;
//   String? location;
//   int? age;
//   String? profile;
//   String? number;
//   List<dynamic>? subscribe;
//
//   UserModel(
//       {
//         this.token,
//         this.uid,
//       this.docId,
//       this.id,
//       this.password,
//       this.nickName,
//       this.name,
//       this.location,
//       this.age,
//       this.profile,
//       this.number,
//       this.subscribe});
//
//   Map<String, dynamic> toMap() {
//     return {
//       'token' : this.token,
//       'uid': this.uid,
//       'name': this.name,
//       'location': this.location,
//       'nickName': this.nickName,
//       'profile': this.profile,
//       'subscribe' : this.subscribe,
//     };
//   }
//   UserModel.fromJson(Map<String, dynamic> json)
//       :
//         token = json['token'] as String,
//         uid = json['uid'] as String,
//         name = json['name'] as String,
//         nickName = json['nickName'] as String,
//         profile = json['profile'] as String,
//         subscribe = json['subscribe'] as List,
//         location = json['location'] as String;
//   //
//   // UserModel.fromJson(Map<String, dynamic> json, String docId)
//   //     :
//   //       token = json['token'] as String,
//   //       uid = json['uid'] as String,
//   //       name = json['name'] as String,
//   //       nickName = json['nickName'] as String,
//   //       profile = json['profile'] as String,
//   //       subscribe = json['subscribe'] as List,
//   //       location = json['location'] as String;
// }
