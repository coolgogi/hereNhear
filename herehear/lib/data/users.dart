class UserModel {
  String uID;
  String ID;
  String password;
  String nickName;
  String name;
  int age;
  String profile;
  String number;
  List<dynamic> subscribe;

  UserModel(
      {required this.uID,
      required this.ID,
      required this.password,
      required this.nickName,
      required this.name,
      required this.age,
      required this.profile,
      required this.number,
      required this.subscribe});
}

List<UserModel> movies = [
  UserModel(
    uID: 'uid1',
    ID: 'coolgogi',
    password: '1234',
    nickName: '쿨고기',
    name: '박수현',
    age: 26,
    profile: 'assets/suheyon.jpg',
    number: '010-6333-5813',
    subscribe: ['2'],
  ),
  UserModel(
    uID: 'uid2',
    ID: 'jskm1451',
    password: '1234',
    name: '장경수',
    age: 26,
    profile: 'assets/gyeongsu.jpg',
    number: '010-6467-1453',
    subscribe: ['1'],
    nickName: 'Captain Jang',
  ),
];