
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/users/data/user_model.dart';

class FirebaseUserRepository {
  static Future<UserModel?> findUserByUid(String uid) async {
    // users collection에 있는 모든 user들을 users에 담음.
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // users collection에서 현재 firebaseUser.uid인 user만 가져와서 이를 data에 옮김
    QuerySnapshot data = await users.where('uid', isEqualTo: uid).get();
    // 여기서 data.size가 0이면 결국 같은 uid를 가진 user가 없다는 뜻.
    if (data.size == 0) {
      return null;
    } else {
      return UserModel.fromJson(data.docs[0].data() as Map<String, dynamic>);
    }
  }

  static Future<void> tokenUpdate(String uid, String? token) async{
    FirebaseFirestore.instance.collection('users').doc(uid).update(
        {'token' : token  });
  }

  static Future<void> platformUpdate(String uid, String? platform) async{
   FirebaseFirestore.instance.collection('users').doc(uid).update(
        {'platform' : platform  });
  }


  static Future<void> saveUserToFirebase(UserModel firebaseUser) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    // firebase의 users collection에 data를 추가하는 것.
   await users.doc(firebaseUser.uid).set(firebaseUser.toJson());
    // user id 반환
  }

  static void updateLoginTime(String? docId) {
    // userdata가 있다면 마지막 로그인 시간을 업데이트 해줘야함.
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update({'last_login_time': DateTime.now()});
  }

  static void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}