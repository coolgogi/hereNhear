import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../broadcast/data/broadcast_model.dart';
import '../groupCall/data/group_call_model.dart';


class AgoraRepository {
  static Future<void> broadcastToFirebase(BroadcastModel newRoom) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('broadcast');

    await users.doc(newRoom.roomInfo.channelName).set(newRoom.toJson());
  }

  static Future<void> groupCallToFirebase(GroupCallModel newRoom) async {
    CollectionReference users =
        FirebaseFirestore.instance.collection('groupcall');

    await users.doc(newRoom.channelName).set(newRoom.toJson());
  }

  static void updateLoginTime(String docId) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users.doc(docId).update({'last_login_time': DateTime.now()});
  }
  // model 합치려다가 다시 원상복구 한 것. by Suhyun
  // static Future<void> BroadcastToFirebase(agoraModel newRoom) async {
  //   CollectionReference users =
  //       FirebaseFirestore.instance.collection('broadcast');
  //
  //   await users.doc(newRoom.docId).set(newRoom.toMap());
  // }

  // static Future<void> GroupCallToFirebase(agoraModel newRoom) async {
  //   CollectionReference users =
  //       FirebaseFirestore.instance.collection('groupcall');
  //
  //   await users.doc(newRoom.docId).set(newRoom.toMap());
  // }

  static void signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
