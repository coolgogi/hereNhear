import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:herehear/broadcast/data/broadcast_model.dart';


class BroadcastRepository {


  static Future<void> saveUserToFirebase(BroadcastModel firebaseUser) async {
    CollectionReference users = FirebaseFirestore.instance.collection('broadcast');
    // firebase의 users collection에 data를 추가하는 것.
    DocumentReference drf = await users.add(firebaseUser.toMap());
    // user id 반환
  }

  static void updateLoginTime(String docId) {
    // userdata가 있다면 마지막 로그인 시간을 업데이트 해줘야함.
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update({'last_login_time': DateTime.now()});
  }

  static void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}