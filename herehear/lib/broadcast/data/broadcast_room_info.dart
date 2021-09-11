

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:herehear/users/data/user_model.dart';

class RoomInfoModel {
  UserModel hostInfo;
  String title;
  List<dynamic> roomCategory;
  String channelName;
  String? notice;
  String? thumbnail;
  bool? private;
  Timestamp? reservation;


  RoomInfoModel({
    required this.hostInfo,
    required this.title,
    required this.roomCategory,
    required this.channelName,
    this.notice,
    this.thumbnail,
    this.private,
    this.reservation,

  });

  // UserModel을 map으로 바꿔주는 함수.
  Map<String, dynamic> toJson() {
    return {
      'hostInfo': this.hostInfo,
      'title': this.title,
      'roomCategory': this.roomCategory,
      'channelName': this.channelName,
      'notice': this.notice,
      'thumbnail': this.thumbnail,
      'private' : this.private,
      'reservation' : this.reservation,
    };
  }
  //
  RoomInfoModel.fromJson(Map<String, dynamic> json)
      : hostInfo = UserModel.fromJson(json['hostInfo'] as Map<String, dynamic>),
        title = json['title'] as String,
        roomCategory = json['roomCategory'] as List<String>,
        channelName = json['channelName'] as String,
        notice = json['notice'] as String,
        private = json['private'] as bool,
        reservation = json['reservation'] as Timestamp,
        thumbnail = json['thumbnail'] as String;
}

