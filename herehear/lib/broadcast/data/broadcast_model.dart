class BroadcastModel {
  String? hostUid;
  String? title;
  String? notice;
  String? category;
  String? docId;
  String? channelName;
  DateTime? createdTime;
  List<dynamic>? currentListener;

  BroadcastModel({
    this.hostUid,
    this.title,
    this.notice,
    this.category,
    this.docId,
    this.channelName,
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
      'docId' : this.docId,
      'channelName' : this.channelName,
      'createdTime' : this.createdTime,
    };
  }

  BroadcastModel.fromJson(Map<String, dynamic> json, String hostUid)
      : hostUid = json['uid'] as String,
        title = json['title'] as String,
        notice = json['notice'] as String,
        category = json['category'] as String,
        docId = json['docId'] as String,
        channelName = json['channelName'] as String,
        createdTime = json['createdTime'].toDate();
}
