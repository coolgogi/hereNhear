class UserModel {
  String? uid;
  String? docId;
  String? ID;
  String? password;
  String? nickName;
  String? name;
  int? age;
  String? profile;
  String? number;
  List<dynamic>? subscribe;

  UserModel(
      {this.uid,
        this.docId,
      this.ID,
      this.password,
      this.nickName,
      this.name,
      this.age,
      this.profile,
      this.number,
      this.subscribe});

  Map<String, dynamic> toMap() {
    return {
      'uid': this.uid,
      'name': this.name,

    };
  }

  UserModel.fromJson(Map<String, dynamic> json, String docId)
      : uid = json['uid'] as String,
        name = json['name'] as String;

}


