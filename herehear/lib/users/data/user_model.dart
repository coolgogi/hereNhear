class UserModel {
  String? token;
  String? uid;
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
      {
        this.token,
        this.uid,
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
      'token' : this.token,
      'uid': this.uid,
      'name': this.name,
      'location': this.location,
      'nickName': this.nickName,
      'profile': this.profile,
      'subscribe' : this.subscribe,
    };
  }

  UserModel.fromJson(Map<String, dynamic> json, String docId)
      : 
        token = json['token'] as String,
        uid = json['uid'] as String,
        name = json['name'] as String,
        nickName = json['nickName'] as String,
        profile = json['profile'] as String,
        subscribe = json['subscribe'] as List,
        location = json['location'] as String;
}
