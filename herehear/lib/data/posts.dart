class PostModel {
  String hostUId;
  String chatRoomId;
  List<dynamic> like;
  List<dynamic> currentListener;
  ChatModel? chatRoom;

  PostModel({
    required this.hostUId,
    required this.chatRoomId,
    required this.like,
    required this.currentListener,
    required this.chatRoom,
  });
}

List<PostModel> posts = [
  PostModel(
      hostUId: 'uid1',
      chatRoomId: 'chat1',
      like: ['장경수', '박수현'],
      currentListener: ['장경수', '박수현'],
      chatRoom: null),
];

class ChatModel {
  String hostUid;
  String chatRoomId;
  List<dynamic> users;
  List<dynamic> currentListener;

  ChatModel({
    required this.hostUid,
    required this.chatRoomId,
    required this.users,
    required this.currentListener,
  });
}

List<ChatModel> chatRooms = [
  ChatModel(
      hostUid: 'uid1',
      chatRoomId: 'chat1',
      users: ['장경수', '박수현'],
      currentListener: ['장경수', '박수현']),
];
