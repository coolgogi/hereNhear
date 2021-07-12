class StreamingModel {
  String? hostUid;
  String? streamingRoomId;
  String? title;
  String? notice;
  String? category;
  List<dynamic>? currentListener;

  StreamingModel({
    this.hostUid,
    this.streamingRoomId,
    this.title,
    this.notice,
    this.category,
    this.currentListener,

  });

  // UserModel을 map으로 바꿔주는 함수.
  Map<String, dynamic> toMap() {
    return {
      'hostUId': this.hostUid,
      'streamingRoomId': this.streamingRoomId,
      'title' : this.title,
      'notice' : this.notice,
      'category' : this.category,
      'currentListener': this.currentListener
    };
  }

}


class GroupCallModel {
  String hostUId;
  String chatRoomId;
  List<dynamic> like;
  List<dynamic> currentListener;


  GroupCallModel({
    required this.hostUId,
    required this.chatRoomId,
    required this.like,
    required this.currentListener,

  });
}



