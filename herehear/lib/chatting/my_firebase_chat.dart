import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:herehear/broadcast/data/broadcast_room_info.dart';
import 'package:herehear/groupCall/data/group_call_model.dart' as types;
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/users/data/user_model.dart';
import '../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/chatting/my_util.dart';
import 'package:herehear/users/data/user_model.dart' as types;
import 'src/class/my_message.dart' as types;
import 'package:herehear/chatting/src/class/my_text_message.dart' as types;
import 'package:herehear/chatting/src/class/my_image_message.dart' as types;
import 'package:herehear/chatting/src/class/my_file_message.dart' as types;

/// Provides access to Firebase chat data. Singleton, use
/// FirebaseChatCore.instance to aceess methods.
class MyFirebaseChatCore {
  MyFirebaseChatCore._privateConstructor() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      firebaseUser = user;
    });
  }

  /// Current logged in user in Firebase. Does not update automatically.
  /// Use [FirebaseAuth.authStateChanges] to listen to the state changes.
  User? firebaseUser = FirebaseAuth.instance.currentUser;

  /// Singleton instance
  static final MyFirebaseChatCore instance =
      MyFirebaseChatCore._privateConstructor();

  /// Creates a chat group room with [users]. Creator is automatically
  /// added to the group. [name] is required and will be used as
  /// a group name. Add an optional [imageUrl] that will be a group avatar
  /// and [metadata] for any additional custom data.
  Future<types.BroadcastModel> createGroupRoom({
    required RoomInfoModel roomInfo,
    required UserModel hostInfo,
  }) async {
    if (firebaseUser == null) return Future.error('User does not exist');

    final currentUser = await fetchUser(hostInfo.uid!);
    final roomUsers = [currentUser];

    final room = await FirebaseFirestore.instance
        .collection('broadcast')
        .doc(roomInfo.channelName)
        .set({
      'title': roomInfo.title,
      'notice': roomInfo.notice,
      'channelName': roomInfo.channelName,
      'roomCategory': roomInfo.roomCategory,
      'thumbnail': roomInfo.thumbnail,
      'location': roomInfo.hostInfo.location,
      'hostNickname': roomInfo.hostInfo.nickName,
      'hostProfile': roomInfo.hostInfo.profile,
      'hostUid': roomInfo.hostInfo.uid,
      'like': 0,
      'createdTime': FieldValue.serverTimestamp(),
      'private' : roomInfo.private,
      //'createdAt': FieldValue.serverTimestamp(),
      // 'imageUrl': imageUrl,
      // 'name': name,
      'type': types.RoomType.group.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': roomUsers.map((u) => u.id).toList(),
      'userRoles': roomUsers.fold<Map<String, String?>>(
        {},
        (previousValue, element) => {
          ...previousValue,
          element.id!: element.role.toString().split('.').last,
        },
      ),
    });

    return types.BroadcastModel(
      roomInfo: roomInfo,
      channelName: roomInfo.channelName,
      hostInfo: roomInfo.hostInfo,
      roomCategory: roomInfo.roomCategory,
      title: roomInfo.title,
      notice: roomInfo.notice,
      type: types.MyRoomType.group,
      users: roomUsers,
    );
  }

  Future<types.GroupCallModel> createGroupCallRoom({
    required RoomInfoModel roomInfo,
    required UserModel hostInfo,
  }) async {
    if (firebaseUser == null) return Future.error('User does not exist');

    final currentUser = await fetchUser(hostInfo.uid!);
    final roomUsers = [currentUser];

    final room = await FirebaseFirestore.instance
        .collection('groupcall')
        .doc(roomInfo.channelName)
        .set({
      'title': roomInfo.title,
      'notice': roomInfo.notice,
      'channelName': roomInfo.channelName,
      'roomCategory': roomInfo.roomCategory,
      'thumbnail': roomInfo.thumbnail,
      'location': roomInfo.hostInfo.location,
      'hostNickname': roomInfo.hostInfo.nickName,
      'hostProfile': roomInfo.hostInfo.profile,
      'hostUid': roomInfo.hostInfo.uid,
      'like': 0,
      'createdTime': FieldValue.serverTimestamp(),
      'private' : roomInfo.private,
      //'createdAt': FieldValue.serverTimestamp(),
      // 'imageUrl': imageUrl,
      // 'name': name,
      'type': types.RoomType.group.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
      'userIds': roomUsers.map((u) => u.id).toList(),
      'userRoles': roomUsers.fold<Map<String, String?>>(
        {},
            (previousValue, element) => {
          ...previousValue,
          element.id!: element.role.toString().split('.').last,
        },
      ),
    });

    return types.GroupCallModel(
      roomInfo: roomInfo,
      channelName: roomInfo.channelName,
      hostInfo: roomInfo.hostInfo,
      title: roomInfo.title,
      notice: roomInfo.notice,
      type: types.MyGroupCallRoomType.group,
      users: roomUsers,
    );
  }

  /// Creates a direct chat for 2 people. Add [metadata] for any additional
  /// custom data.
  // Future<types.BroadcastModel> createRoom(
  //     types.User otherUser, {
  //       Map<String, dynamic>? metadata,
  //     }) async {
  //   if (firebaseUser == null) return Future.error('User does not exist');
  //
  //   final query = await FirebaseFirestore.instance
  //       .collection('broadcast')
  //     //  .where('userIds', arrayContains: firebaseUser!.uid)
  //       .get();
  //
  //   final rooms = await processRoomsQuery(firebaseUser!, query);
  //
  //   try {
  //     return rooms.firstWhere((room) {
  //       if (room.type == types.MyRoomType.group) return false;
  //
  //       final userIds = room.users!.map((u) => u.id);
  //       return userIds.contains(firebaseUser!.uid) &&
  //           userIds.contains(otherUser.id);
  //     });
  //   } catch (e) {
  //     // Do nothing if room does not exist
  //     // Create a new room instead
  //   }
  //
  //   final currentUser = await fetchUser(firebaseUser!.uid);
  //   final users = [currentUser, otherUser];
  //
  //   final room = await FirebaseFirestore.instance.collection('broadcast').add({
  //     'createdAt': FieldValue.serverTimestamp(),
  //     'imageUrl': null,
  //     'metadata': metadata,
  //     'name': null,
  //     'type': types.RoomType.direct.toShortString(),
  //     'updatedAt': FieldValue.serverTimestamp(),
  //     'userIds': null,
  //     'userRoles': null,
  //   });
  //
  //   return types.BroadcastModel(
  //     id: room.id,
  //     metadata: metadata,
  //     type: types.MyRoomType.direct,
  //     users: users,
  //   );
  // }

  /// Creates [types.User] in Firebase to store name and avatar used on
  /// rooms list
  Future<void> createUserInFirestore(types.User user) async {
    await FirebaseFirestore.instance.collection('users').doc(user.id).set({
      'createdAt': FieldValue.serverTimestamp(),
      'firstName': user.firstName,
      'imageUrl': user.imageUrl,
      'lastName': user.lastName,
      'lastSeen': user.lastSeen,
      'metadata': user.metadata,
      'role': user.role?.toShortString(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Removes [types.User] from `users` collection in Firebase
  Future<void> deleteUserFromFirestore(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  /// Returns a stream of messages from Firebase for a given room
  Stream<List<types.MyMessage>> messages(types.BroadcastModel room) {
    return FirebaseFirestore.instance
        .collection('broadcast/${room.channelName}/messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.fold<List<types.MyMessage>>(
          [],
          (previousValue, element) {
            final data = element.data();
            print(room.users);
            final author = room.users.firstWhere(
              (u) => u.id == data['authorId'],
              orElse: () => types.UserModel(id: data['authorId'] as String),
            );

            data['author'] = author.toJson();
            data['id'] = element.id;
            try {
              data['createdAt'] = element['createdAt']?.millisecondsSinceEpoch;
              data['updatedAt'] = element['updatedAt']?.millisecondsSinceEpoch;
            } catch (e) {
              // Ignore errors, null values are ok
            }
            data.removeWhere((key, value) => key == 'authorId');
            return [...previousValue, types.MyMessage.fromJson(data)];
          },
        );
      },
    );
  }

  /// Returns a stream of changes in a room from Firebase
  Stream<types.BroadcastModel> room(String roomId) {
    if (firebaseUser == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('broadcast')
        .doc(roomId)
        .snapshots()
        .asyncMap((doc) => processRoomDocument(doc, firebaseUser!));
  }

  /// Returns a stream of rooms from Firebase. Only rooms where current
  /// logged in user exist are returned. [orderByUpdatedAt] is used in case
  /// you want to have last modified rooms on top, there are a couple
  /// of things you will need to do though:
  /// 1) Make sure `updatedAt` exists on all rooms
  /// 2) Write a Cloud Function which will update `updatedAt` of the room
  /// when the room changes or new messages come in
  /// 3) Create an Index (Firestore Database -> Indexes tab) where collection ID
  /// is `rooms`, field indexed are `userIds` (type Arrays) and `updatedAt`
  /// (type Descending), query scope is `Collection`
  Stream<List<types.BroadcastModel>> broadcastRoomsWithLocation(
      {bool orderByUpdatedAt = false}) {
    if (firebaseUser == null) {
      return const Stream.empty();
    }
    final collection = FirebaseFirestore.instance.collection('broadcast').where(
        'location',
        isEqualTo: UserController.to.myProfile.value.location);

    return collection
        .snapshots()
        .asyncMap((query) => processRoomsQuery(firebaseUser!, query));
  }

  Stream<List<types.GroupCallModel>> groupCallRoomsWithLocation(
      {bool orderByUpdatedAt = false}) {
    if (firebaseUser == null) {
      return const Stream.empty();
    }
    final collection = FirebaseFirestore.instance.collection('groupcall').where(
        'location',
        isEqualTo: UserController.to.myProfile.value.location);

    return collection
        .snapshots()
        .asyncMap((query) => processGroupCallRoomsQuery(firebaseUser!, query));
  }

  Stream<List<types.BroadcastModel>> rooms({bool orderByUpdatedAt = false}) {
    if (firebaseUser == null) {
      return const Stream.empty();
    }
    final collection = FirebaseFirestore.instance.collection('broadcast');

    return collection
        .snapshots()
        .asyncMap((query) => processRoomsQuery(firebaseUser!, query));
  }

  /// Sends a message to the Firestore. Accepts any partial message and a
  /// room ID. If arbitraty data is provided in the [partialMessage]
  /// does nothing.
  void sendMessage(dynamic partialMessage, String roomId) async {
    if (firebaseUser == null) return;

    types.MyMessage? message;
    //DateTime createdTime = DateTime.now();
    Timestamp createdTime = Timestamp.now();
    String channelName =
        (10000000000000 - createdTime.millisecondsSinceEpoch).toString();

    if (partialMessage is types.PartialFile) {
      message = types.MyFileMessage.fromPartial(
        author: types.UserModel(id: firebaseUser!.uid),
        id: '',
        partialFile: partialMessage,
      );
    } else if (partialMessage is types.PartialImage) {
      message = types.MyImageMessage.fromPartial(
        author: types.UserModel(id: firebaseUser!.uid),
        id: '',
        partialImage: partialMessage,
      );
    } else if (partialMessage is types.PartialText) {
      message = types.MyTextMessage.fromPartial(
        author: types.UserModel(id: firebaseUser!.uid),
        id: '',
        partialText: partialMessage,
      );
    }

    if (message != null) {
      final messageMap = message.toJson();
      messageMap.removeWhere((key, value) => key == 'author' || key == 'id');
      messageMap['authorId'] = firebaseUser!.uid;
      messageMap['createdAt'] = createdTime;
      messageMap['updatedAt'] = FieldValue.serverTimestamp();

      await FirebaseFirestore.instance
          .collection('broadcast/$roomId/messages')
          .doc(channelName)
          .set(messageMap);
    }
  }

  /// Updates a message in the Firestore. Accepts any message and a
  /// room ID. Message will probably be taken from the [messages] stream.
  void updateMessage(types.MyMessage message, String roomId) async {
    if (firebaseUser == null) return;
    if (message.author.id != firebaseUser!.uid) return;

    final messageMap = message.toJson();
    messageMap.removeWhere((key, value) => key == 'id' || key == 'createdAt');
    messageMap['updatedAt'] = FieldValue.serverTimestamp();

    await FirebaseFirestore.instance
        .collection('broadcast/$roomId/messages')
        .doc(message.id)
        .update(messageMap);
  }

  /// Returns a stream of all users from Firebase
  Stream<List<types.UserModel>> users() {
    if (firebaseUser == null) return const Stream.empty();
    return FirebaseFirestore.instance.collection('users').snapshots().map(
          (snapshot) => snapshot.docs.fold<List<types.UserModel>>(
            [],
            (previousValue, element) {
              if (firebaseUser!.uid == element.id) return previousValue;

              return [...previousValue, processUserDocument(element)];
            },
          ),
        );
  }
}
