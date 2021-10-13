import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'package:herehear/groupCall/data/group_call_model.dart';
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
  var imageUrl = doc.data()?['imageUrl'] as String?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  final type = doc.data()!['type'] as String;
  final channelName = doc.data()!['channelName'] as String;
  final userIds = doc.data()!['userIds'] as List<dynamic>;
  final userRoles = doc.data()?['userRoles'] as Map<String, dynamic>?;
  final like = doc.data()?['like'] as int;
  final hostInfo = await fetchUser(doc.data()?['hostUid']);
  final title = doc.data()!['title'] as String;
  final notice = doc.data()!['notice'] as String;
  final List roomCategory = doc.data()!['roomCategory'] as List;
  final roomInfo = RoomInfoModel(
      hostInfo: hostInfo,
      title: title,
      notice: notice,
      roomCategory: roomCategory,
      channelName: channelName);

  final users = await Future.wait(
    userIds.map(
      (userId) => fetchUser(
        userId as String,
        role: types.getMyRoleFromString(userRoles?[userId] as String?),
      ),
    ),
  );

  final room = types.BroadcastModel(
    roomInfo: roomInfo,
    like: like,
    imageUrl: imageUrl,
    metadata: metadata,
    location: locationController.location.value,
    type: types.getMyRoomTypeFromString(type),
    users: users,
  );


  return room;
}



Future<List<GroupCallModel>> processGroupCallRoomsQuery(
    User firebaseUser,
    QuerySnapshot<Map<String, dynamic>> query,
    ) async {
  final futures = query.docs.map(
        (doc) => processGroupCallRoomDocument(doc, firebaseUser),
  );

  return await Future.wait(futures);
}

/// Returns a [types.Room] created from Firebase document
Future<GroupCallModel> processGroupCallRoomDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
    User firebaseUser,
    ) async {
  final LocationController locationController = Get.find();
  var imageUrl = doc.data()?['imageUrl'] as String?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  final type = doc.data()!['type'] as String;
  final channelName = doc.data()!['channelName'] as String;
  final userIds = doc.data()!['userIds'] as List<dynamic>;
  final userRoles = doc.data()?['userRoles'] as Map<String, dynamic>?;
  final like = doc.data()?['like'] as int?;
  final hostInfo = await fetchUser(doc.data()?['hostUid']);
  final title = doc.data()!['title'] as String;
  final notice = doc.data()!['notice'] as String;
  final List roomCategory = doc.data()!['roomCategory'] as List;
  final roomInfo = RoomInfoModel(
      hostInfo: hostInfo,
      title: title,
      notice: notice,
      roomCategory: roomCategory,
      channelName: channelName);

  final users = await Future.wait(
    userIds.map(
          (userId) => fetchUser(
        userId as String,
        role: types.getMyRoleFromString(userRoles?[userId] as String?),
      ),
    ),
  );


  final room = GroupCallModel(
    type: types.getMyGroupCallTypeFromString(type),
    users: users,
    hostInfo: hostInfo,
    roomInfo: roomInfo,
    // like: like,
    channelName: channelName,
    // imageUrl: imageUrl,
    // metadata: metadata,
     location: locationController.location.value,
    // type: types.getMyRoomTypeFromString(type),
    // users: users,
  );
  return room;
}


/// Returns a [types.User] created from Firebase document
types.UserModel processUserDocument(
  DocumentSnapshot<Map<String, dynamic>> doc, {
  types.MyRole? role,
}) {
  final createdAt = doc.data()?['createdAt'] as Timestamp?;
  final imageUrl = doc.data()?['imageUrl'] as String?;
  final lastSeen = doc.data()?['lastSeen'] as Timestamp?;
  final metadata = doc.data()?['metadata'] as Map<String, dynamic>?;
  final roleString = doc.data()?['role'] as String?;
  final updatedAt = doc.data()?['updatedAt'] as Timestamp?;

  final nickName = doc.data()?['nickName'] as String?;
  final uid = doc.data()?['uid'] as String?;
  final profile = doc.data()?['profile'] as String?;

  final user = types.UserModel(
    nickName: nickName,
    uid: uid,
    profile: profile,
    createdAt: createdAt?.millisecondsSinceEpoch,
    id: doc.id,
    imageUrl: imageUrl,
    lastSeen: lastSeen?.millisecondsSinceEpoch,
    metadata: metadata,
    role: role ?? types.getMyRoleFromString(roleString),
    updatedAt: updatedAt?.millisecondsSinceEpoch,
  );

  return user;
}
