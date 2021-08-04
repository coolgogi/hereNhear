class BroadcastModel {
  //using both side.
  String? hostUid;
  String? title;
  String? notice;
  String? channelName;
  String? docId;
  String? image;
  String? location;
  DateTime? createdTime;
  List<String>? currentListener;
  //only broadcast
  String? category;
  int? like;
  String? hostProfile;
  List<String>? userProfile;
  String? hostNickname;
  List<String>? userNickname;

  BroadcastModel({
    this.hostUid,
    this.title,
    this.notice,
    this.channelName,
    this.docId,
    this.image,
    this.location,
    this.createdTime,
    this.currentListener,
    //only broadcast
    this.category,
    this.like,
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
      'channelName': this.channelName,
      'docId': this.docId,
      'image': this.image,
      'location': this.location,
      'createdTime': this.createdTime,
      'currentListener': this.currentListener,
      //only broadcast
      'category': this.category,
      'like': this.like,
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
        channelName = json['channelName'] as String,
        docId = json['docId'] as String,
        image = json['image'] as String,
        createdTime = json['createdTime'].toDate(),
        //only broadcast
        category = json['category'] as String,
        like = json['like'] as int;
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

