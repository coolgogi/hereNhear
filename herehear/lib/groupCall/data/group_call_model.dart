class GroupCallModel {
  String? hostUid;
  String? title;
  String? notice;
  String? channelName;
  String? docId;
  DateTime? createdTime;
  List<dynamic>? currentListener;

  GroupCallModel({
    this.hostUid,
    this.title,
    this.notice,
    this.channelName,
    this.docId,
    this.createdTime,
    this.currentListener,
  });

  Map<String, dynamic> toMap() {
    return {
      'hostUId': this.hostUid,
      'title': this.title,
      'notice': this.notice,
      'channelName': this.channelName,
      'docId': this.docId,
      'createTIme' : this.createdTime,
      'currentListener': this.currentListener,
    };
  }

  GroupCallModel.fromJson(Map<String, dynamic> json, String docId)
      : hostUid = json['uid'] as String,
        title = json['title'] as String,
        notice = json['notice'] as String,
        channelName = json['title'] as String,
        docId = json['docId'] as String,
        createdTime = json['createdTime'].toDate();
}
