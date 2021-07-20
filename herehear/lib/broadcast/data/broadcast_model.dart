class BroadcastModel {
  String? hostUid;
  String? title;
  String? notice;
  String? category;
  String? docId;
  String? image;
  int? like;
  String? channelName;
  DateTime? createdTime;
  List<dynamic>? currentListener;
  String? hostProfile;
  List<String>? userProfile;
  String? hostNickname;
  List<String>? userNickname;

  BroadcastModel({
    this.hostUid,
    this.title,
    this.notice,
    this.category,
    this.docId,
    this.image,
    this.like,
    this.channelName,
    this.createdTime,
    this.currentListener,
    this.hostProfile,
    this.userProfile,
    this.hostNickname,
    this.userNickname,
  });

  // UserModel을 map으로 바꿔주는 함수.
  Map<String, dynamic> toMap() {
    return {
      'hostUid': this.hostUid,
      'title': this.title,
      'notice': this.notice,
      'category': this.category,
      'docId': this.docId,
      'image': this.image,
      'like': this.like,
      'channelName': this.channelName,
      'createdTime': this.createdTime,
      'currentListener': currentListener,
      'hostProfile': this.hostProfile,
      'hostNickName': this.hostNickname,
      'userProfile': this.userProfile,
      'userNickName': this.userNickname,
    };
  }

  BroadcastModel.fromJson(Map<String, dynamic> json, String hostUid)
      : hostUid = json['uid'] as String,
        title = json['title'] as String,
        notice = json['notice'] as String,
        category = json['category'] as String,
        docId = json['docId'] as String,
        image = json['image'] as String,
        like = json['like'] as int,
        channelName = json['channelName'] as String,
        createdTime = json['createdTime'].toDate();
}
