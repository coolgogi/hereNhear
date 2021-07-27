// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:herehear/appBar/create_broadcast.dart';
// import 'package:herehear/appBar/create_groupcall.dart';
// import 'package:herehear/appBar/searchBar.dart';
// import 'package:herehear/broadcast/broadcast.dart';
// import 'package:herehear/broadcast/broadcastList.dart';
// import 'package:herehear/location_data/location.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:herehear/groupCall/group_call.dart';
//
// class SubscribedPage extends StatelessWidget {
//   var refreshKey = GlobalKey<RefreshIndicatorState>();
//
//   FirebaseAuth auth = FirebaseAuth.instance;
//   FirebaseFirestore firestore = FirebaseFirestore.instance;
//   late Map<String, dynamic> _data;
//   SubscribedPage.withData(Map<String, dynamic> data) {
//     _data = data;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(44.0.h),
//         child: AppBar(
//           title:
//           Text('구독', style: Theme.of(context).appBarTheme.titleTextStyle),
//           actions: <Widget>[
//             // IconButton(
//             //     onPressed: _showMyDialog,
//             //     color: Colors.amber,
//             //     icon: Icon(Icons.add_circle)),
//             IconButton(
//               onPressed: () {
//                 showModalBottomSheet(
//                     context: context,
//                     builder: (context) {
//                       return Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: <Widget>[
//                           ListTile(
//                             leading: new Icon(Icons.photo),
//                             title: new Text('Photo'),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           ListTile(
//                             leading: new Icon(Icons.music_note),
//                             title: new Text('Music'),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           ListTile(
//                             leading: new Icon(Icons.videocam),
//                             title: new Text('Video'),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                           ListTile(
//                             leading: new Icon(Icons.share),
//                             title: new Text('Share'),
//                             onTap: () {
//                               Navigator.pop(context);
//                             },
//                           ),
//                         ],
//                       );
//                     });
//               },
//               color: Colors.black87,
//               icon: Image.asset('assets/icons/notification.png'),
//               iconSize: 20.w,
//             ),
//             Padding(
//               padding: EdgeInsets.only(right: 8.0.w),
//               child: IconButton(
//                 icon: Image.asset('assets/icons/search.png'),
//                 iconSize: 20.w,
//                 onPressed: () {
//                   showSearch(
//                     context: context,
//                     delegate: PostSearchDelegate(),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//       body: RefreshIndicator(
//         key: refreshKey,
//         onRefresh: refreshList,
//         child: ListView(
//           // padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
//           children: <Widget>[
//             Padding(
//               padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
//               child: Text(
//                 '팔로잉 라이브',
//                 // style: Theme.of(context).textTheme.headline1,
//                 style: Theme.of(context).textTheme.headline2,
//               ),
//             ),
//             Padding(
//               padding:
//               EdgeInsets.only(left: 16.0.w, top: 12.0.h, bottom: 20.0.h),
//               child: Container(
//                 height: 173.0.h,
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: firestore.collection("broadcast").snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (!snapshot.hasData)
//                       return Container(
//                         child: Text('라이브중인 방송이 없습니다.'),
//                       );
//                     return ListView(
//                       scrollDirection: Axis.horizontal,
//                       children: broadcastRoomList(context, snapshot, _data),
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 16.0.w),
//               child: Row(
//                 children: [
//                   Text(
//                     '팔로우 중인 카테고리',
//                     style: Theme.of(context).textTheme.headline2,
//                   ),
//                   Expanded(child: Container()),
//                   Padding(
//                     padding: EdgeInsets.only(right: 17.0.w),
//                     child: InkWell(
//                       child: Text(
//                         '편집',
//                         style: TextStyle(
//                             color: Colors.grey, fontWeight: FontWeight.w700),
//                       ),
//                       onTap: null,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             Padding(
//               padding:
//               EdgeInsets.only(left: 16.0.w, top: 8.0.h, bottom: 25.0.h),
//               child: Container(
//                 height: 27.0.h,
//                 child: ListView(
//                     scrollDirection: Axis.horizontal,
//                     children: List.generate(3, (int index) {
//                       return Padding(
//                         padding: EdgeInsets.only(right: 8.0.w),
//                         child: TextButton(
//                           child: Text(
//                             '카테고리 ${index + 1}',
//                             style: TextStyle(
//                                 fontSize: 13.13.sp,
//                                 color: Theme.of(context).colorScheme.onPrimary),
//                           ),
//                           style: ButtonStyle(
//                               backgroundColor: MaterialStateProperty.all<Color>(
//                                   Theme.of(context).colorScheme.primary),
//                               shape: MaterialStateProperty.all<
//                                   RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(14.r),
//                                     // side: BorderSide(color: Colors.red),
//                                   ))),
//                           onPressed: null,
//                         ),
//                       );
//                     })),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(left: 16.0.w),
//               child: Text(
//                 '마이 토크',
//                 style: Theme.of(context).textTheme.headline2,
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.only(top: 5.h),
//               child: StreamBuilder<QuerySnapshot>(
//                   stream: firestore.collection("groupcall").snapshots(),
//                   builder: (BuildContext context,
//                       AsyncSnapshot<QuerySnapshot> snapshot) {
//                     if (!snapshot.hasData)
//                       return Container(
//                         child: Center(child: Text('생성된 대화방이 없습니다.')),
//                       );
//                     return Column(
//                       children: groupcallRoomList(context, snapshot),
//                     );
//                   }),
//             ),
//           ],
//         ),
//       ),
//       // floatingActionButtonLocation:
//       //     FloatingActionButtonLocation.miniCenterFloat,
//       // floatingActionButton: FloatingActionButton.extended(
//       //   onPressed: null, //사용자 위치 기반으로 데이터 다시 불러오기 및 새로고침
//       //   label: Text(
//       //     '새로 고침',
//       //     style: TextStyle(
//       //       color: Colors.black87,
//       //     ),
//       //   ),
//       //   backgroundColor: Colors.white,
//       // ),
//     );
//   }
//
//   Future<void> refreshList() async {
//     refreshKey.currentState?.show(atTop: false);
//     await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
//     ///////////////////////////////////////////////////////////////////////////////////
//     // await controller.getLocation().obs; <-- 이거 대신 적절한 로드 로직 넣으면 됩니다!//
//     //////////////////////////////////////////////////////////////////////////////////
//   }
//
//   // Future<void> _showMyDialog() async {
//   //   return Get.defaultDialog(
//   //     title: '소리 시작하기',
//   //     content: SingleChildScrollView(
//   //       child: Column(
//   //         children: <Widget>[
//   //           TextButton(
//   //             child: Text(
//   //               '개인 라이브',
//   //               style: TextStyle(fontSize: 18.sp, color: Colors.black87),
//   //             ),
//   //             onPressed: () => Get.off(() => CreateBroadcastPage()),
//   //           ),
//   //           TextButton(
//   //             child: Text(
//   //               '그룹 대화',
//   //               style: TextStyle(fontSize: 18.sp, color: Colors.black87),
//   //             ),
//   //             onPressed: () => Get.off(() => CreateGroupCallPage()),
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   // Route _createRoute() {
//   //   return PageRouteBuilder(
//   //     pageBuilder: (context, animation, secondaryAnimation) =>
//   //         CreateBroadcastPage(),
//   //     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//   //       var begin = Offset(0.0, 1.0);
//   //       var end = Offset.zero;
//   //       var curve = Curves.ease;
//   //
//   //       var tween =
//   //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//   //
//   //       return SlideTransition(
//   //         position: animation.drive(tween),
//   //         child: child,
//   //       );
//   //     },
//   //   );
//   // }
//
//   List<Widget> groupcallRoomList(
//       BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
//     return broadcastSnapshot.data!.docs.map((room) {
//       return Column(
//         children: [
//           Divider(thickness: 2),
//           Container(
//             // width: MediaQuery.of(context).size.width,
//             height: 80.0.h,
//             child: InkWell(
//               onTap: () {
//                 firestore.collection('groupcall').doc(room['docId']).update({
//                   'currentListener':
//                   FieldValue.arrayUnion([auth.currentUser!.uid])
//                 });
//                 Get.to(() => GroupCallPage(), arguments: room['channelName']);
//               },
//               child: Row(
//                 children: <Widget>[
//                   Padding(
//                     padding: EdgeInsets.only(left: 16.0.w, right: 8.0.w),
//                     child: Container(
//                       // margin: EdgeInsets.all(0.0.w),
//                       width: 70.0.h,
//                       height: 70.0.h,
//                       child: SizedBox(
//                         child: Image.asset(room['image']),
//                       ),
//                     ),
//                   ),
//                   Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Text(
//                         room['title'],
//                         style: Theme.of(context).textTheme.headline6,
//                       ),
//                       SizedBox(
//                         height: 5.h,
//                       ),
//                       Text(
//                         room['notice'],
//                         style: Theme.of(context).textTheme.subtitle1,
//                       )
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       );
//     }).toList();
//   }
// }

//from broadcast.dart

// /// Helper function to get list of native views
// List<Widget> _getRenderViews() {
//   final List<Widget> list = [];
//   // //프로필 이미지 받아오는 거 어떻게 할지 고민중이었음. 비디오 기능 없애고 오디오 기능으로ㅇㅇ
//   list.add(Image(
//     image: AssetImage('assets/images/me.jpg'),
//     width: 150,
//     height: 150,
//   ));
//
//   controller.users.forEach((int uid) {
//     print("@@@@@@@@@@@@@: ${controller.speakingUser.length}");
//     bool flag = false;
//     for (int i = 0; i < controller.speakingUser.length; i++) {
//       if (uid == controller.speakingUser[i]) {
//         list.add(Container(
//             decoration: BoxDecoration(
//               border: Border.all(
//                 color: Colors.lightGreen,
//                 width: 2,
//               ),
//             ),
//             child: Image(
//               image: AssetImage('assets/images/you.png'),
//               width: 150,
//               height: 150,
//             )));
//         flag = true;
//         break;
//       }
//     }
//     if (flag != true)
//       list.add(Image(
//         image: AssetImage('assets/images/you.png'),
//         width: 150,
//         height: 150,
//       ));
//   });
//   return list;
// }

// /// Video view wrapper
// Widget _videoView(view) {
//   return Expanded(
//       child: Container(
//           child: Center(
//     child: view,
//   )));
// }

// /// Video view row wrapper
// Widget _expandedVideoRow(List<Widget> views) {
//   final wrappedViews = views.map<Widget>(_videoView).toList();
//   return Expanded(
//     child: Row(
//       children: wrappedViews,
//     ),
//   );
// }

/// Video layout wrapper
// Widget _viewRows() {
//   final views = _getRenderViews();
//   switch (views.length) {
//     case 1:
//       return Container(
//           child: Column(
//         children: <Widget>[_videoView(views[0])],
//       ));
//     case 2:
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow([views[0]]),
//           _expandedVideoRow([views[1]])
//           // views[0],
//           // views[1]
//         ],
//       ));
//     case 3:
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 2)),
//           _expandedVideoRow(views.sublist(2, 3))
//         ],
//       ));
//     case 4:
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow(views.sublist(0, 2)),
//           _expandedVideoRow(views.sublist(2, 4))
//         ],
//       ));
//     default:
//   }
//   return Container();
// }
