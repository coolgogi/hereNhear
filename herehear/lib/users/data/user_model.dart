class UserModel {
  String? uid;
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
      this.ID,
      this.password,
      this.nickName,
      this.name,
      this.age,
      this.profile,
      this.number,
      this.subscribe});
}

UserModel u1 = UserModel();
