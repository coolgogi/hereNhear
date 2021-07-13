class BroadcastModel {
  String? hostUid;
  String? streamingRoomId;
  String? title;
  String? notice;
  String? category;
  DateTime? createdTime;
  List<dynamic>? currentListener;

  BroadcastModel({
    this.hostUid,
    this.streamingRoomId,
    this.title,
    this.notice,
    this.category,
    this.createdTime,
    this.currentListener,

  });

  // UserModel을 map으로 바꿔주는 함수.
  Map<String, dynamic> toMap() {
    return {
      'hostUid': this.hostUid,
      'title' : this.title,
      'notice' : this.notice,
      'category' : this.category,
      'createdTime' : this.createdTime,
    };
  }

  BroadcastModel.fromJson(Map<String, dynamic> json, String hostUid)
      : hostUid = json['uid'] as String,
        title = json['title'] as String,
        notice = json['notice'] as String,
        category = json['category'] as String,
        createdTime = json['createdTime'].toDate();
}
