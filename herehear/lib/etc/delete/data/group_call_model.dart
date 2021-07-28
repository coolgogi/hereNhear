// class GroupCallModel {
//   String? hostUid;
//   String? title;
//   String? notice;
//   String? channelName;
//   String? docId;
//   String? image;
//   String? location;
//   DateTime? createdTime;
//   List<dynamic>? currentListener;
//   List<dynamic>? participants;
//
//   GroupCallModel({
//     this.hostUid,
//     this.title,
//     this.notice,
//     this.channelName,
//     this.docId,
//     this.image,
//     this.location,
//     this.createdTime,
//     this.currentListener,
//     this.participants,
//   });
//
//   Map<String, dynamic> toMap() {
//     return {
//       'hostUId': this.hostUid,
//       'title': this.title,
//       'notice': this.notice,
//       'channelName': this.channelName,
//       'docId': this.docId,
//       'image' : this.image,
//       'location' : this.location,
//       'createTIme' : this.createdTime,
//       'currentListener': this.currentListener,
//       'participants' : this.participants,
//     };
//   }
//
//   GroupCallModel.fromJson(Map<String, dynamic> json, String docId)
//       : hostUid = json['uid'] as String,
//         title = json['title'] as String,
//         notice = json['notice'] as String,
//         channelName = json['title'] as String,
//         docId = json['docId'] as String,
//         image = json['image'] as String,
//         createdTime = json['createdTime'].toDate();
// }
