class UserModel {
  String uid;
  String? docId;
  String? id;
  String? password;
  String? nickName;
  String? name;
  String? location;
  int? age;
  String? profile;
  String? number;
  List<dynamic>? subscribe;

  UserModel(
      {required this.uid,
      this.docId,
      this.id,
      this.password,
      this.nickName,
      this.name,
      this.location,
      this.age,
      this.profile,
      this.number,
      this.subscribe});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,
      'location': this.location,
      'nickName': this.nickName,
      'profile': this.nickName,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json, String docId)
      : uid = json['uid'] as String,
        name = json['name'] as String,
        nickName = json['nickName'] as String,
        profile = json['profile'] as String,
        location = json['location'] as String;
}
