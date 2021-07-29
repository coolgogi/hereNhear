// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:herehear/groupCall/data/group_call_model.dart';
//
//
// class GroupCallRepository {
//   static Future<void> GroupCallToFirebase(GroupCallModel newRoom) async {
//     CollectionReference users = FirebaseFirestore.instance.collection('groupcall');
//
//     await users.doc(newRoom.docId).set(newRoom.toMap());
//
//   }
//
//   static void updateLoginTime(String docId) {
//     CollectionReference users = FirebaseFirestore.instance.collection('users');
//     users.doc(docId).update({'last_login_time': DateTime.now()});
//   }
//
//   static void signOut() async {
//     await FirebaseAuth.instance.signOut();
//   }
// }
