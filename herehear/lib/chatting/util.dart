import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:herehear/broadcast/broadcast_model.dart' as types;

/// Fetches user from Firebase and returns a promise
Future<types.User> fetchUser(String userId, {types.Role? role}) async {
  final doc =
  await FirebaseFirestore.instance.collection('users').doc(userId).get();

  return processUserDocument(doc, role: role);
}

/// Returns a list of [types.Room] created from Firebase query.
/// If room has 2 participants, sets correct room name and image.
Future<List<types.BroadcastModel>> processRoomsQuery(
    User firebaseUser,
    QuerySnapshot<Map<String, dynamic>> query,
    ) async {
  final futures = query.docs.map(
        (doc) => processRoomDocument(doc),
  );

  return await Future.wait(futures);
}

/*
  String? hostUid;
  String? title;
  String? notice;
  String? channelName;
  String? docId;
  String? image;
  String? location;
  DateTime? createdTime;
  List<String>? currentListener;
  //only broadcast
  String? category;
  int? like;
  String? hostProfile;
  List<String>? userProfile;
  String? hostNickname;
  List<String>? userNickname;
 */


/// Returns a [types.Room] created from Firebase document
Future<types.BroadcastModel> processRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    ) async {
  print('777777777777777777777777777777777777777777777777777777777777');
  print(doc.data()?['hostUid']);
  final hostUid = doc.data()?['hostUid'] as String? ;
  final hostNickname = doc.data()?['hostNickname'] ;
  final like = doc.data()?['like'] ;
  final category = doc.data()?['category'];
  var title = doc.data()?['title'];
  final notice = doc.data()?['notice'] ;
  final userProfile = doc.data()?['userProfile'];
  final location = doc.data()?['location'] ;
  final createdTime = doc.data()!['createdTime'] ;
  final currentListener = doc.data()?['currentListener'];

  print('goooooooooooooooooooooooood');

  final room = types.BroadcastModel(
    hostNickname: hostUid,

  );
  print('return');
  return room;
}

/// Returns a [types.User] created from Firebase document
types.User processUserDocument(
    DocumentSnapshot<Map<String, dynamic>> doc, {
      types.Role? role,
    }) {
  final createdAt = doc.data()?['createdAt'] as Timestamp?;
  final firstName = doc.data()?['firstName'] as String?;
  final imageUrl = doc.data()?['imageUrl'] as String?;
  final lastName = doc.data()?['lastName'] as String?;
  final lastSeen = doc.data()?['lastSeen'] as Timestamp?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  final roleString = doc.data()?['role'] as String?;
  final updatedAt = doc.data()?['updatedAt'] as Timestamp?;

  final user = types.User(
    createdAt: createdAt?.millisecondsSinceEpoch,
    firstName: firstName,
    id: doc.id,
    imageUrl: imageUrl,
    lastName: lastName,
    lastSeen: lastSeen?.millisecondsSinceEpoch,
    metadata: metadata,
    role: role ?? types.getRoleFromString(roleString),
    updatedAt: updatedAt?.millisecondsSinceEpoch,
  );

  return user;
}
