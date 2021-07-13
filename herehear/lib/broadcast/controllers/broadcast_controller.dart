//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:herehear/login/signIn.dart';
// import 'package:herehear/data/posts.dart';
//
// import 'package:get/get.dart';
//
// // 전체 과정 //
// // firebaseUser를 받으면 일단 firebaseUser를.uid를 이용해서 이미 데이터베이스에 있는지 없는지 확인
// // 없으면 'users' collection을 생성한 뒤에 여기다 해당 정볼르 add 해줘야함.
// // 근데 firebase에 업로드를 하기 위해서는 Map 형식이여야 하는데, 여기서 현재 firebase는 User type이므로
// // 이를 Map으로 바꿔서 해줘야함.
// // 그래서 UserModle을 만든 다음에 toMap함수를 넣어서 이를 Map으로 바꿔준다음에 firebase DB에 업로드
//
// class StreamingController extends GetxController {
//   // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
//   static StreamingController get to => Get.find();
//   Rx<BroadCastModel> newStreamingRoom = BroadCastModel().obs;
//   String? docId;
//
//
//   String? hostUid;
//   String? streamingRoomId;
//   String? title;
//   String? notice;
//   String? category;
//   List<dynamic>? currentListener;
//
//
//   void createBroadCastRoom(User firebaseUser) async {
//     if (firebaseUser != null) {    //로그인 된 상태
//       // firebaseUserData가 null이면 firebase database에 등록이 안된 유저
//
//         newStreamingRoom.value = BroadCastModel(
//           hostUid: firebaseUser.uid,
//           streamingRoomId: firebaseUser.displayName,
//           title:
//         );
//
//         docId =
//         await FirebaseUserRepository.saveUserToFirebase(myProfile.value);
//         myProfile.value.docId = docId;
//
//     }
//     else{
//       Get.to(LoginPage());
//     }
//   }
// }