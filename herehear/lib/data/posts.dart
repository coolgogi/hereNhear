class PostModel {
  String hostUId;
  String chatRoomId;
  List<dynamic> like;
  List<dynamic> currentListener;



  PostModel(
      {
        this.hostUId,
        this.chatRoomId,
        this.like,
        this.currentListener,
        });
}

List<PostModel> movies = [
  PostModel(
    hostUId: '1',
    chatRoomId: '1',
    like: ['장경수', '박수현'],
    currentListener: ['장경수', '박수현']

  ),

];