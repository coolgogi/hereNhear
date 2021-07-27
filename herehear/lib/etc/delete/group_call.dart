// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import '../utils/AppID.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// // import 'package:agora_rtc_engine/rtc_local_view.dart' as RtcLocalView;
// // import 'package:agora_rtc_engine/rtc_remote_view.dart' as RtcRemoteView;
//
// class AgoraEventController extends GetxController {
//   var infoStrings = <String>[].obs;
//   var users = <int>[].obs;
//   RxBool muted = false.obs;
//   var speakingUser = <int?>[].obs;
//   var participants = <int>[].obs;
//   late RtcEngine _engine;
//   var activeSpeaker = 10.obs;
//   int currentUid = 0;
//   RxBool is_participate = false.obs;
//   final String? currentUserUID = FirebaseAuth.instance.currentUser!.uid;
//   var docID = Get.arguments;
//   // var groupcallStream = Stream<DocumentSnapshot<Map<String, dynamic>>>().obs;
//   var participantsList = <Widget>[].obs;
//   var currentListenerList = <Widget>[].obs;
//   var participantsDataList = <dynamic>[].obs;
//   var listenerDataList = <dynamic>[].obs;
//
//   var userStream = FirebaseFirestore.instance.collection("users").obs;
//   var roomStream = FirebaseFirestore.instance.collection('groupcall').doc(Get.arguments).snapshots().obs;
//
//
//
//   Stream<DocumentSnapshot<Map<String, dynamic>>> getGroupcallStream(String docID) {
//     return FirebaseFirestore.instance.collection('groupcall').doc(docID).snapshots();
//   }
//
//
//   @override
//   void onInit() async {
//     // called immediately after the widget is allocated memory
//     await initialize();
//     super.onInit();
//   }
//
//   @override
//   void onClose() async {
//     // clear users
//     users.clear();
//     // destroy sdk
//     _engine.leaveChannel().obs;
//     _engine.destroy().obs;
//     await FirebaseFirestore.instance
//         .collection("groupcall")
//         .doc(docID)
//         .update({"currentListener": FieldValue.arrayRemove([currentUserUID])});
//     await FirebaseFirestore.instance
//         .collection("groupcall")
//         .doc(docID)
//         .update({"participants": FieldValue.arrayRemove([currentUserUID])});
//     super.onClose();
//   }
//
//   Future<void> initialize() async {
//     if (appID.isEmpty) {
//       infoStrings.add(
//         'APP_ID missing, please provide your APP_ID in settings.dart',
//       );
//       infoStrings.add('Agora Engine is not starting');
//       return;
//     }
//     await _initAgoraRtcEngine();
//     _addAgoraEventHandlers();
//     // await _engine.enableWebSdkInteroperability(true);
//     await _engine.enableAudioVolumeIndication(250, 2, true);
//     print("ggggggggggggggggggggggggggggg");
//
//     // await getToken();
//     // print('token : $token');
//     // await _engine?.joinChannel(token, widget.channelName, null, 0);
//     await _engine.joinChannel(null, GroupCallPage().channelName, null, 0);
//   }
//
//   void getWatcherDataList(List currentListener) {
//     // var userList = FirebaseFirestore.instance.collection("users");
//
//     currentListener.forEach((uid) {
//       print('^^^?: ${uid}');
//       userStream.value.where('uid', isEqualTo: uid.toString())
//           .get().then((data) {
//         var user = data.docs.first;
//         print('****: ${user['nickName']}');
//         if(!listenerDataList.contains(user))
//           listenerDataList.add(user);
//         print('ASDFASDFA: ${listenerDataList.first}');
//       });
//     });
//     print('list.length: ${listenerDataList}');
//     print('^_______________________^');
//   }
//
//   Future<void> removeWatcherDataList(List currentListener) async {
//     // var userList = FirebaseFirestore.instance.collection("users");
//
//     currentListener.forEach((uid) {
//       print('^^^?: ${uid}');
//       userStream.value.where('uid', isEqualTo: uid.toString())
//           .get().then((data) {
//         var user = data.docs.first;
//         print('****: ${user['nickName']}');
//         listenerDataList.remove(user);
//         print('Deleted!: ${listenerDataList.first}');
//       });
//     });
//     print('list.length: ${listenerDataList}');
//     print('^_______________________^');
//   }
//
//   void getParticipantDataList(List currentListener) {
//     // var userList = FirebaseFirestore.instance.collection("users");
//
//     FirebaseFirestore.instance.collection("users");
//
//     currentListener.forEach((uid) {
//       print('^^^?: ${uid}');
//       userStream.value.where('uid', isEqualTo: uid.toString())
//           .get().then((data) {
//         var user = data.docs.first;
//         print('****: ${user['nickName']}');
//         if(!participantsDataList.contains(user))
//           participantsDataList.add(user);
//         print('ㅁㄴㅇㄻㄴㅇㄻㄹ: ${participantsDataList.first}');
//       });
//     });
//     print('list.length: ${participantsDataList}');
//     print('^_______________________^');
//   }
//
//   /// Create agora sdk instance and initialize
//   Future<void> _initAgoraRtcEngine() async {
//     _engine = await RtcEngine.create(appID);
//     // await _engine?.enableVideo();
//     await _engine.enableAudio();
//   }
//
//   /// Add agora event handlers
//   Future<void> _addAgoraEventHandlers() async {
//     print('################################################################');
//     _engine.setEventHandler(RtcEngineEventHandler(
//       error: (code) {
//         final info = 'onError: $code';
//         infoStrings.add(info);
//       },
//       joinChannelSuccess: (channel, uid, elapsed) {
//         final info = 'onJoinChannel: $channel, uid: $uid';
//         currentUid = uid;
//         infoStrings.add(info);
//       },
//       leaveChannel: (stats) async {
//         infoStrings.add('onLeaveChannel');
//         users.clear();
//         participants.clear();
//         await FirebaseFirestore.instance
//             .collection("groupcall")
//             .doc(docID)
//             .update({"currentListener": FieldValue.arrayRemove([currentUserUID])});
//         await FirebaseFirestore.instance
//             .collection("groupcall")
//             .doc(docID)
//             .update({"participants": FieldValue.arrayRemove([currentUserUID])});
//       },
//       userJoined: (uid, elapsed) async {
//         final info = 'userJoined: $uid';
//         currentUid = uid;
//         infoStrings.add(info);
//         await FirebaseFirestore.instance
//             .collection("groupcall")
//             .doc(docID)
//             .update({"currentListener": FieldValue.arrayUnion([currentUserUID])});
//         users.add(uid);
//         // FirebaseFirestore.instance.collection('groupcall').
//       },
//       userOffline: (uid, reason) {
//         final info = 'userOffline: $uid , reason: $reason';
//         infoStrings.add(info);
//         users.remoers, totalVolume) {
//         speakingUser.clear();
//         speakingUser
//             .addAll(speakers.obs.map((element) => element.uid).toList());
//         // print('!!!!!!!!!!!!!!: ${speakingUser.value.asMap().entries.}');
//
//         // print(
//         //     '*************************: ${speakingUser.isEmpty ? null : speakingUser}');
//       },
//       // activeSpeaker: (uid) {
//       //   activeSpeaker = uid.obs;
//       // }
//       // tokenPrivilegeWillExpire: (token) async {
//       //   await getToken();
//       //   await _engine?.renewToken(token);
// activeSpeaker: (uid) {
//   activeSpeaker = uid.obs;
// }
// tokenPrivilegeWillExpire: (token) async {
//   await getToken();
//   await _engine?.renewToken(token);
// },
// ));
//       // },
//     ));
//   }
//
//   void move_watcher_to_participant() async {
//     // users.removeWhere((element) => element == currentUid);
//     // participants.add(currentUid);
//     print('After Remove!!: ${listenerDataList.length}');
//     FirebaseFirestore.instance.collection('groupcall').doc(docID).update({"currentListener": FieldValue.arrayRemove([currentUserUID])});
//     FirebaseFirestore.instance.collection('groupcall').doc(docID).update({"participants": FieldValue.arrayUnion([currentUserUID])});
//     List currentUser = [docID];
//     getParticipantDataList(currentUser);
//     await removeWatcherDataList(currentUser);
//     // listenerDataList.removeWhere((element) => element['uid'] == docID);
//     print('After Remove!!: ${listenerDataList.length}');
//     is_participate = true.obs;
//     print('?!?!?: ${participants.length}');
//   }
//
//   void onToggleMute() {
//     muted.value = !muted.value;
//     _engine.muteLocalAudioStream(muted.value);
//   }
//
//   void onSwitchCamera() {
//     _engine.switchCamera();
//   }
// }
//
// class GroupCallPage22 extends StatelessWidget {
//   final String channelName = Get.arguments;
//   bool already_join = false;
//
//   final controller = Get.put(AgoraEventController());
//
//   /// Toolbar layout
//   // Widget _toolbar() {
//   //   return Container(
//   //     alignment: Alignment.bottomCenter,
//   //     padding: const EdgeInsets.symmetric(vertical: 48),
//   //     child: Row(
//   //       mainAxisAlignment: MainAxisAlignment.center,
//   //       children: <Widget>[
//   //         Obx(
//   //           () => RawMaterialButton(
//   //             onPressed: controller.onToggleMute,
//   //             child: Icon(
//   //               controller.muted.value ? Icons.mic_off : Icons.mic,
//   //               color:
//   //                   controller.muted.value ? Colors.white : Colors.blueAccent,
//   //               size: 20.0,
//   //             ),
//   //             shape: CircleBorder(),
//   //             elevation: 2.0,
//   //             fillColor:
//   //                 controller.muted.value ? Colors.blueAccent : Colors.white,
//   //             padding: const EdgeInsets.all(12.0),
//   //           ),
//   //         ),
//   //         RawMaterialButton(
//   //           onPressed: () => _onCallEnd(),
//   //           child: Icon(
//   //             Icons.call_end,
//   //             color: Colors.white,
//   //             size: 35.0,
//   //           ),
//   //           shape: CircleBorder(),
//   //           elevation: 2.0,
//   //           fillColor: Colors.redAccent,
//   //           padding: const EdgeInsets.all(15.0),
//   //         ),
//   //         RawMaterialButton(
//   //           onPressed: controller.onSwitchCamera,
//   //           child: Icon(
//   //             Icons.switch_camera,
//   //             color: Colors.blueAccent,
//   //             size: 20.0,
//   //           ),
//   //           shape: CircleBorder(),
//   //           elevation: 2.0,
//   //           fillColor: Colors.white,
//   //           padding: const EdgeInsets.all(12.0),
//   //         )
//   //       ],
//   //     ),
//   //   );
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black,
//         title: Text('Here&Hear'),
//         actions: <Widget>[
//           Padding(
//             padding: EdgeInsets.only(top: 10.0.h, right: 8.0.w),
//             child: Column(
//               children: <Widget>[
//                 Icon(Icons.people),
//                 Text('999+', style: TextStyle(fontSize: 10),),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Image.asset('assets/icons/exit.png', width: 23.w, color: Colors.white,),
//             onPressed: () => _onCallEnd(),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: StreamBuilder<DocumentSnapshot<Object>>(
//         stream: FirebaseFirestore.instance.collection('groupcall').doc(channelName).snapshots(),
//         builder: (context, snapshot) {
//           if(!snapshot.hasData) return Text('loading..');
//
//           controller.getParticipantDataList(snapshot.data!['participants']);
//           controller.getWatcherDataList(snapshot.data!['currentListener']);
//
//           String hostUID = snapshot.data?['hostUId'];
//           // controller.participantsList = _getParticipantsImageList(snapshot.data!['participants'], hostUID).obs;
//           // controller.currentListenerList = _getWatcherImageList(snapshot.data!['currentListener']).obs;
//           // controller.listenerDataList.value = _getWatcherDataList(snapshot.data!['currentListener']);
//           controller.currentListenerList = _getWatcherImageList().obs;
//           controller.participantsList = _getParticipantsImageList().obs;
//
//           return Column(
//                 children: [
//                   Container(
//                     height: 288.h,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(12),
//                         bottomRight: Radius.circular(12),
//                       ),
//                       color: Theme.of(context).colorScheme.primary,
//                     ),
//                     child: Padding(
//                       padding: EdgeInsets.only(left: 16.0.w),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: 30.0.h),
//                             child: Text(
//                               '참여',
//                               style: Theme.of(context).textTheme.headline2,
//                             ),
//                           ),
//                           Row(
//                             children: [
//                               Obx(() {
//                                 print(controller.listenerDataList);
//                                 return _viewRows(_getParticipantsImageList());
//                               }),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.only(top: 25.0.h, left: 16.0.w),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '관전',
//                           style: Theme.of(context).textTheme.headline2,
//                         ),
//                         Row(
//                           children: <Widget>[
//                             Obx(() => _viewRows(_getWatcherImageList())),
//                           ],
//                         )
//                       ],
//                     ),
//                   ),
//                 ],
//               );
//         }
//       ),
//       bottomNavigationBar: bottomBar(context),
//     );
//   }
//
//   /// Helper function to get list of native views
//   // List<Widget> _getRenderViews() {
//   //   final List<StatefulWidget> list = [];
//   //   list.add(RtcLocalView.SurfaceView());
//   //   _users.forEach((int uid) {
//   //     list.add(RtcRemoteView.SurfaceView(uid: uid));
//   //   });
//   //   return list;
//   // }
//   List<Widget> _getParticipantsImageList() {
//     return controller.participantsDataList.map((user) {
//       bool flag = false;
//       for (int i = 0; i < controller.speakingUser.length; i++) {
//         if ((controller.participantsDataList.length <= 2) && (controller.speakingUser[i] != 0)) {
//           flag = true;
//           return Padding(
//             padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//             child: Column(
//               children: [
//                 Stack(
//                   alignment: Alignment.center,
//                   children: <Widget>[
//                     CircleAvatar(
//                       radius: 40,
//                       backgroundColor: Colors.lightGreen,
//                     ),
//                     CircleAvatar(
//                       radius: 35,
//                       backgroundImage: AssetImage(user['profile']),
//                     ),
//                   ],
//                 ),
//                 Text(user['nickName'], style: TextStyle(color: Colors.white),),
//               ],
//             ),
//           );
//         }
//       }
//         return Padding(
//           padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//           child: Column(
//             children: [
//               Container(
//                 child: CircleAvatar(
//                   radius: 35,
//                   backgroundImage: AssetImage(user['profile']),
//                 ),
//               ),
//               Text(user['nickName'], style: TextStyle(color: Colors.white),),
//             ],
//           ),
//         );
//     }).toList();
//   }
//
//   // List<Widget> _getParticipantsImageList(List participants, String hostUID) {
//   //   List<Widget> list = [];
//   //   List? participantsData;
//   //
//   //   var userList = FirebaseFirestore.instance.collection("users");
//   //
//   //   // print('^_______________________^');
//   //   participants.forEach((uid) {
//   //     // print('^^^?: ${uid}');
//   //     userList.where('uid', isEqualTo: uid.toString())
//   //         .get().then((user) => list.add(Padding(
//   //       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //       child: Column(
//   //         children: [
//   //           Container(
//   //             child: CircleAvatar(
//   //               radius: 35,
//   //               backgroundImage: AssetImage(user.docs.first['profile']),
//   //             ),
//   //           ),
//   //           Text(user.docs.first['nickName'], style: TextStyle(color: Colors.black),),
//   //         ],
//   //       ),
//   //     )));
//   //   });
//   //   print(list.length);
//   //   // print('^_______________________^');
//   //
//   //   participants.forEach((uid) {
//   //     StreamBuilder<DocumentSnapshot<Object>>(
//   //         stream: FirebaseFirestore.instance.collection("users").doc(uid.toString()).snapshots(),
//   //         builder: (context, snapshot) {
//   //           print('!!!!!!!!!!!!!!: ${snapshot.data}');
//   //           participantsData!.add(snapshot.data);
//   //           bool flag = false;
//   //           for (int i = 0; i < controller.speakingUser.length; i++) {
//   //             if ((participantsData.length <= 2) && (controller.speakingUser[i] != 0)) {
//   //               list.add(Padding(
//   //                 padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //                 child: Column(
//   //                   children: [
//   //                     Stack(
//   //                       alignment: Alignment.center,
//   //                       children: <Widget>[
//   //                         CircleAvatar(
//   //                           radius: 40,
//   //                           backgroundColor: Colors.lightGreen,
//   //                         ),
//   //                         CircleAvatar(
//   //                           radius: 35,
//   //                           backgroundImage: AssetImage(snapshot.data!['profile']),
//   //                         ),
//   //                       ],
//   //                     ),
//   //                     Text(snapshot.data!['nickName'], style: TextStyle(color: Colors.white),),
//   //                   ],
//   //                 ),
//   //               ));
//   //               flag = true;
//   //               break;
//   //             }
//   //           }
//   //           if (flag != true)
//   //             list.add(Padding(
//   //               padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //               child: Column(
//   //                 children: [
//   //                   Container(
//   //                     child: CircleAvatar(
//   //                       radius: 35,
//   //                       backgroundImage: AssetImage(snapshot.data!['profile']),
//   //                     ),
//   //                   ),
//   //                   Text(snapshot.data!['nickName'], style: TextStyle(color: Colors.white),),
//   //                 ],
//   //               ),
//   //             ));
//   //           return Text('asdf');
//   //         }
//   //       );
//   //     }
//   //   );
//   //
//   //   return list;
//   //
//   //
//   //   // if(!participants.isEmpty) {
//   //   //   list.add(Padding(
//   //   //     padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //     child: Container(
//   //   //       child: CircleAvatar(
//   //   //         radius: 35,
//   //   //         backgroundImage: AssetImage('assets/images/me.jpg'),
//   //   //       ),
//   //   //     ),
//   //   //   ));
//   //   // }
//   //   //
//   //   // controller.participants.forEach((int uid) {
//   //   //   // print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
//   //   //   bool flag = false;
//   //   //   for (int i = 0; i < controller.speakingUser.length; i++) {
//   //   //     if (uid == controller.speakingUser[i]) {
//   //   //       list.add(Padding(
//   //   //         padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //         child: Container(
//   //   //           child: CircleAvatar(
//   //   //             radius: 40,
//   //   //             backgroundColor: Colors.lightGreen,
//   //   //             child: CircleAvatar(
//   //   //               radius: 35,
//   //   //               backgroundImage: AssetImage('assets/images/you.png'),
//   //   //             ),
//   //   //           ),
//   //   //         ),
//   //   //       ));
//   //   //       flag = true;
//   //   //       break;
//   //   //     }
//   //   //   }
//   //   //   if (flag != true)
//   //   //     list.add(Padding(
//   //   //       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //       child: Container(
//   //   //         child: CircleAvatar(
//   //   //           radius: 35,
//   //   //           backgroundImage: AssetImage('assets/images/you.png'),
//   //   //         ),
//   //   //       ),
//   //   //     ));
//   //   //   // list.add(RtcRemoteView.SurfaceView(uid: uid));
//   //   // });
//   //   // return list;
//   // }
//
//   // List<Widget> _getWatcherImageList(List currentListener) {
//   //   List<Widget> list = [];
//   //   var userList = FirebaseFirestore.instance.collection("users");
//   //
//   //   print('list.length: ${list.length}');
//   //   print('^_______________________^');
//   //   currentListener.forEach((uid) {
//   //     print('^^^?: ${uid}');
//   //     userList.where('uid', isEqualTo: uid.toString())
//   //         .get().then((data) {
//   //           var user = data.docs.first;
//   //           print('****: ${user['nickName']}');
//   //           list.add(Padding(
//   //             padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //             child: Column(
//   //               children: [
//   //                 Container(
//   //                   child: CircleAvatar(
//   //                     radius: 35,
//   //                     backgroundImage: AssetImage(data.docs.first['profile']),
//   //                   ),
//   //                 ),
//   //                 Text(data.docs.first['nickName'], style: TextStyle(color: Colors.black),),
//   //               ],
//   //             ),
//   //           ));
//   //     });
//   //   });
//   //   print('list.length: ${list.length}');
//   //   print('^_______________________^');
//   //
//   //
//   //   // currentListener.forEach((uid) {
//   //   //   print('uuuuid: ${uid.toString()}');
//   //   //   StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//   //   //       stream: FirebaseFirestore.instance.collection("users").where('uid',
//   //   //           isEqualTo: uid.toString())
//   //   //           .snapshots(),
//   //   //       builder: (context, snapshot) {
//   //   //         if(!snapshot.hasData) return Text('no');
//   //   //         print('!!!!!!!!!!!!!!: ${snapshot.data}');
//   //   //         print('????????@?????: ${snapshot.data}');
//   //   //         list.add(Padding(
//   //   //           padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //           child: Column(
//   //   //             children: [
//   //   //               Container(
//   //   //                 child: CircleAvatar(
//   //   //                   radius: 35,
//   //   //                   backgroundImage: AssetImage(snapshot.data!.docs.first.data()['profile']),
//   //   //                 ),
//   //   //               ),
//   //   //               Text(snapshot.data!.docs.first.data()['nickName'], style: TextStyle(color: Colors.black),),
//   //   //             ],
//   //   //           ),
//   //   //         ));
//   //   //         return CircularProgressIndicator(color: Colors.black,);
//   //   //       }
//   //   //   );
//   //   // }
//   //   // );
//   //   return list;
//   //
//   //   // if(!controller.is_participate.value){
//   //   //   list.add(Padding(
//   //   //       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //       child: Container(
//   //   //         child: CircleAvatar(
//   //   //           radius: 35,
//   //   //           backgroundImage: AssetImage('assets/images/me.jpg'),
//   //   //         ),
//   //   //       ),
//   //   //     )
//   //   //     //     Container(
//   //   //     //   decoration: BoxDecoration(
//   //   //     //     shape: BoxShape.circle,
//   //   //     //     image: DecorationImage(
//   //   //     //       fit: BoxFit.fill,
//   //   //     //       image: AssetImage('assets/images/me.jpg'),
//   //   //     //     ),
//   //   //     //   ),
//   //   //     // )
//   //   //   );
//   //   // }
//   //   //
//   //   //
//   //   // controller.users.forEach((int uid) {
//   //   //   print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
//   //   //   bool flag = false;
//   //   //   for (int i = 0; i < controller.speakingUser.length; i++) {
//   //   //     if (uid == controller.speakingUser[i]) {
//   //   //       list.add(Padding(
//   //   //         padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //         child: Container(
//   //   //           child: CircleAvatar(
//   //   //             radius: 40,
//   //   //             backgroundColor: Colors.lightGreen,
//   //   //             child: CircleAvatar(
//   //   //               radius: 35,
//   //   //               backgroundImage: AssetImage('assets/images/you.png'),
//   //   //             ),
//   //   //           ),
//   //   //         ),
//   //   //       )
//   //   //           // Container(
//   //   //           // decoration: BoxDecoration(
//   //   //           //   shape: BoxShape.circle,
//   //   //           //   border: Border.all(
//   //   //           //     color: Colors.lightGreen,
//   //   //           //     width: 2,
//   //   //           //   ),
//   //   //           // ),
//   //   //           // child: Image(
//   //   //           //   image: AssetImage('assets/images/you.png'),
//   //   //           //   width: 150,
//   //   //           //   height: 150,
//   //   //           // ))
//   //   //           );
//   //   //       flag = true;
//   //   //       break;
//   //   //     }
//   //   //   }
//   //   //   if (flag != true)
//   //   //     list.add(Padding(
//   //   //       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//   //   //       child: Container(
//   //   //         child: CircleAvatar(
//   //   //           radius: 35,
//   //   //           backgroundImage: AssetImage('assets/images/you.png'),
//   //   //         ),
//   //   //       ),
//   //   //     ));
//   //   //   // list.add(RtcRemoteView.SurfaceView(uid: uid));
//   //   // });
//   //   // return list;
//   // }
//
//
//
//   // List<dynamic> _getWatcherDataList(List currentListener) {
//   //   List list = [];
//   //   List l = [];
//   //   var userList = FirebaseFirestore.instance.collection("users");
//   //
//   //   // print('list.length: ${list.length}');
//   //   print('^_______________________^');
//   //   currentListener.forEach((uid) {
//   //     print('^^^?: ${uid}');
//   //     userList.where('uid', isEqualTo: uid.toString())
//   //         .get().then((data) {
//   //       var user = data.docs.first;
//   //       print('****: ${user['nickName']}');
//   //
//   //       if(!list.contains(data))
//   //         list.add(user);
//   //
//   //       print('ASDFASDFA: ${list.first}');
//   //     });
//   //   });
//   //   print('list.length: ${list}');
//   //   print('^_______________________^');
//   //
//   //   return list;
//   // }
//
//   List<Widget> _getWatcherImageList() {
//     return controller.listenerDataList.map((user) => Padding(
//       padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//       child: Column(
//         children: [
//           Container(
//             child: CircleAvatar(
//               radius: 35,
//               backgroundImage: AssetImage(user['profile']),
//             ),
//           ),
//           Text(user['nickName'], style: TextStyle(color: Colors.black),),
//         ],
//       ),
//     )).toList();
//   }
//
//   /// Video view wrapper
//   Widget _videoView(view) {
//     return Container(
//         child: Center(
//       child: view,
//     ));
//   }
//
//   /// Video view row wrapper
//   Widget _expandedVideoRow(List<Widget> views) {
//     final wrappedViews = views.map<Widget>(_videoView).toList();
//     return Row(
//       children: wrappedViews,
//     );
//   }
//
//   // Widget _viewWatcher() {
//   //   return
//   // }
//
//   Widget bottomBar(BuildContext context) {
//     return BottomAppBar(
//       color: Colors.black,
//       child: Row(
//         children: [
//           Padding(
//             padding: EdgeInsets.fromLTRB(16.0.w, 10.0.w, 10.0.w, 10.0.w),
//             child: InkWell(
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.chat, color: Colors.black),
//               ),
//               onTap: null,
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: 50.h,
//             ),
//           ),
//           Obx(
//               () => Padding(
//                 padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
//                 child: InkWell(
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: controller.muted.value ? Theme.of(context).colorScheme.primary : Colors.white,
//                     child: Icon(
//                       controller.muted.value ? Icons.mic_off : Icons.mic,
//                       color:
//                       !already_join ? Colors.grey
//                           : controller.muted.value ? Colors.white : Colors.black,
//                       size: 30,
//                     ),
//                   ),
//                   onTap: (() {
//                     if (already_join == true)
//                       controller.onToggleMute();
//                   }),
//                 ),
//               )
//           ),
//           Padding(
//             padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
//             child: InkWell(
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.white,
//                 child: Icon(Icons.pan_tool_outlined, color: Colors.black, size: 28,),
//               ),
//               onTap: (() {
//                 if (already_join == false)
//                   controller.move_watcher_to_participant();
//
//                 already_join = true;
//               }),
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   /// Video layout wrapper
//   Widget _viewRows(List<Widget> userImageList) {
//     // final views = _getRenderViews();
//     var views = userImageList;
//     print('asdfasdf: $views');
//
//     if (views.length == 1) {
//       return Container(
//           child: Column(
//         children: <Widget>[_videoView(views[0])],
//       ));
//     } else if (views.length <= 5) {
//       return Container(
//           child: Column(
//             children: <Widget>[_expandedVideoRow(views.sublist(0, views.length)),],
//           ));
//     } else if (views.length <= 10) {
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 5)),
//           _expandedVideoRow(views.sublist(5, views.length - 1))
//         ],
//       ));
//     } else if (views.length <= 15) {
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 5)),
//           _expandedVideoRow(views.sublist(5, 10)),
//           _expandedVideoRow(views.sublist(15, views.length - 1))
//         ],
//       ));
//     } else if (views.length <= 20) {
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 5)),
//           _expandedVideoRow(views.sublist(5, 10)),
//           _expandedVideoRow(views.sublist(10, 15)),
//           _expandedVideoRow(views.sublist(15, views.length - 1))
//         ],
//       ));
//     }
//     return Container();
//   }
//
//   void _onCallEnd() {
//     controller.onClose();
//     Get.back();
//     Get.back();
//     Get.back();
//   }
// }
