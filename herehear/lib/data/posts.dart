class PostModel {
  String hostUId;
  String chatRoomId;
  List<dynamic> like;
  List<dynamic> currentListener;
  ChatModel chatRoom;



  PostModel(
      {
        this.hostUId,
        this.chatRoomId,
        this.like,
        this.currentListener,
        });
}

List<PostModel> posts = [
  PostModel(
    hostUId: 'uid1',
    chatRoomId: 'chat1',
    like: ['장경수', '박수현'],
    currentListener: ['장경수', '박수현']

  ),

];

class ChatModel {
  String hostUid;
  String chatRoomId;
  List<dynamic> users;
  List<dynamic> currentListener;



  ChatModel(
      {
        this.hostUid,
        this.chatRoomId,
        this.users,
        this.currentListener,
      });
}

List<ChatModel> chatRooms = [
  ChatModel(
      hostUid: 'uid1',
      chatRoomId: 'chat1',
      users: ['장경수', '박수현'],
      currentListener: ['장경수', '박수현']

  ),

];