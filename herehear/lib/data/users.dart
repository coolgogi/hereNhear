class UserModel {
  final String name;
  final int age;
  final String profile;
  final String number;
  final List<dynamic> interests;
  final List<dynamic> scrap;



  UserModel(
      {
        this.name,
        this.age,
        this.profile,
        this.number,
        this.interests,
        this.scrap});
}

List<UserModel> movies = [
  UserModel(
    name: '박수현',
    age: 26,
    profile: 'assets/suheyon.jpg',
    number: '010-6333-5813',
    interests: ['클라이밍'],
    scrap: [''],
  ),
  UserModel(
    name: '장경수',
    age: 26,
    profile: 'assets/gyeongsu.jpg',
    number: '010-6333-5813',
    interests: ['운동'],
    scrap: [''],
  ),

];