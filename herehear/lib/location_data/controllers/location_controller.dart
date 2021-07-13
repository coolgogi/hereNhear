// import 'package:get/get.dart';
//
// class LocationController extends GetxController {
//   // Get.find<ProfileController>()대신에 ProfileController.to ~ 라고 쓸 수 있음
//   static LocationController get to => Get.find();
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