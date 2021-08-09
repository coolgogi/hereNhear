import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/location/controller/location_controller.dart';
import 'package:herehear/users/data/user_model.dart' as types;
import 'package:herehear/chatting/util.dart' as types;


/// Fetches user from Firebase and returns a promise
Future<types.UserModel> fetchUser(String userId, {types.MyRole? role}) async {
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
        (doc) => processRoomDocument(doc, firebaseUser),
  );


  return await Future.wait(futures);
}

/// Returns a [types.Room] created from Firebase document
Future<types.BroadcastModel> processRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    ) async {
  final LocationController locationController = Get.find();


  final createdAt = doc.data()?['createdAt'] as Timestamp?;
  var imageUrl = doc.data()?['imageUrl'] as String?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  var name = doc.data()?['name'] as String?;
  final type = doc.data()!['type'] as String;
  final docId = doc.data()!['docId'] as String;
  final updatedAt = doc.data()?['updatedAt'] as Timestamp?;
  final userIds = doc.data()!['currentListener'] as List<dynamic>;
  final userRoles = doc.data()?['userRoles'] as Map<String, dynamic>?;
  final like = doc.data()?['like'] as int?;
  final hostInfo = await fetchUser(doc.data()?['hostUid']);

  final users = await Future.wait(
    userIds.map(
          (userId) => fetchUser(
        userId as String,
        role: types.getMyRoleFromString(userRoles?[userId] as String?),
      ),
    ),
  );

  if (type == types.MyRoomType.direct.toShortString()) {
    try {
      final otherUser = users.firstWhere(
            (u) => u.id != firebaseUser.uid,
      );

      imageUrl = otherUser.imageUrl;
      name = '${otherUser.firstName ?? ''} ${otherUser.lastName ?? ''}'.trim();
    } catch (e) {
      // Do nothing if other user is not found, because he should be found.
      // Consider falling back to some default values.
    }
  }

  final room = types.BroadcastModel(
    hostInfo:hostInfo ,
    like : like,
    createdAt: createdAt?.millisecondsSinceEpoch,
    id: docId,
    docId: docId,
    imageUrl: imageUrl,
    metadata: metadata,
    name: name,
    location:locationController.location.value ,
    type: types.getMyRoomTypeFromString(type),
    updatedAt: updatedAt?.millisecondsSinceEpoch,
    users: users,
  );


  return room;
}

/// Returns a [types.User] created from Firebase document
types.UserModel processUserDocument(
    DocumentSnapshot<Map<String, dynamic>> doc, {
      types.MyRole? role,
    }) {
  final createdAt = doc.data()?['createdAt'] as Timestamp?;
  final firstName = doc.data()?['firstName'] as String?;
  final imageUrl = doc.data()?['imageUrl'] as String?;
  final lastName = doc.data()?['lastName'] as String?;
  final lastSeen = doc.data()?['lastSeen'] as Timestamp?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  final roleString = doc.data()?['role'] as String?;
  final updatedAt = doc.data()?['updatedAt'] as Timestamp?;

  final user = types.UserModel(
    createdAt: createdAt?.millisecondsSinceEpoch,
    firstName: firstName,
    id: doc.id,
    imageUrl: imageUrl,
    lastName: lastName,
    lastSeen: lastSeen?.millisecondsSinceEpoch,
    metadata: metadata,
    role: role ?? types.getMyRoleFromString(roleString),
    updatedAt: updatedAt?.millisecondsSinceEpoch,
  );

  return user;
}
