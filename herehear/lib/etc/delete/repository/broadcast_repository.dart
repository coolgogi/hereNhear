// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:herehear/broadcast/data/broadcast_model.dart';
//
// class BroadcastRepository {
//   static Future<void> BroadcastToFirebase(BroadcastModel firebaseUser) async {
//     CollectionReference users =
//         FirebaseFirestore.instance.collection('broadcast');
//
//     await users.doc(firebaseUser.docId).set(firebaseUser.toMap());
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
