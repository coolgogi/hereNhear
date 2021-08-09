

import 'package:herehear/users/data/user_model.dart';

class RoomInfoModel {
  UserModel hostInfo;
  String title;
  List<String> roomCategory;
  String docId;
  String? notice;
  String? thumbnail;


  RoomInfoModel({
    required this.hostInfo,
    required this.title,
    required this.roomCategory,
    required this.docId,
    this.notice,
    this.thumbnail,
  });

  // UserModel을 map으로 바꿔주는 함수.
  Map<String, dynamic> toMap() {
    return {
      'hostInfo': this.hostInfo,
      'title': this.title,
      'roomCategory': this.roomCategory,
      'docId': this.docId,
      'notice': this.notice,
      'thumbnail': this.thumbnail,
    };
  }
  //
  RoomInfoModel.fromJson(Map<String, dynamic> json)
      : hostInfo = UserModel.fromJson(json['hostInfo'] as Map<String, dynamic>),
        title = json['title'] as String,
        roomCategory = json['roomCategory'] as List<String>,
        docId = json['docId'] as String,
        notice = json['notice'] as String,
        thumbnail = json['thumbnail'] as String;
        // createdTime = json['createdTime'].toDate(),
        // //only broadcast
        // category = json['category'] as String,
        // like = json['like'] as int;
}

// Map<String, dynamic> toJson() => {
//   'hostUid': createdAt,
//   'title': id,
//   'notice': imageUrl,
//   'channelName': lastMessages?.map((e) => e.toJson()).toList(),
//   'docId': metadata,
//   'image': name,
//   'createdTime': type.toShortString(),
//   'category': updatedAt,
//   'like': users.map((e) => e.toJson()).toList(),
// };
