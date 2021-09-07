import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:herehear/agora/agoraEventController.dart';
import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/participant_profile.dart';



class GroupCallPage extends StatelessWidget {
  String? _title;
  GroupCallPage(this._title);
  final String channelName = Get.arguments;
  int participantNum = 0;
  int listenerNum = 0;
  List<int> lastSpeakingUser = [];

  bool alreadyJoin = false;

  late final controller = Get.put(AgoraEventController.groupcall(
      channelName: channelName, role: ClientRole.Broadcaster));


  @override
  Widget build(BuildContext context) {
    controller.isGroupCallPageNow.value = true;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.h),
        child: Padding(
          padding: EdgeInsets.only(top: 15.0.h),
          child: AppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: _onCallEnd),
            title: Text('HEAR CHAT', style: Theme.of(context).textTheme.headline1),
            titleSpacing: 0.0,
            actions: <Widget>[
              IconButton(
                  onPressed: null,
                  icon: Image.asset('assets/icons/bell_white.png', height: 18.0.h)),
              IconButton(
                  onPressed: null,
                  icon: Image.asset('assets/icons/more_white.png', height: 17.0.h)),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            height: 288.h,
            child: Padding(
              padding: EdgeInsets.only(left: 16.0.w, right: 21.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 10.0.h),
                    child: Row(
                      children: [
                        Text(
                          _title!,
                          style: Theme.of(context).textTheme.headline4!.copyWith(
                            color: Theme.of(context).colorScheme.primaryVariant,
                          ),
                        ),
                        SizedBox(width: 9.w),
                        Container(
                          width: 42.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(8.r)),
                            border: Border.all(color: Theme.of(context).colorScheme.primary,)
                          ),
                          child: Center(
                            child: Text('12:35', style: Theme.of(context).textTheme.headline6!.copyWith(
                              color: Theme.of(context).colorScheme.primary)),
                          ),
                        ),
                        Expanded(child: Container()),
                        Column(
                          children: <Widget>[
                            Icon(Icons.people),
                            Text(
                              '999+',
                              style: TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20.0.h),
                    child: Text(
                      'Speakers',
                      style: Theme.of(context).textTheme.headline4!.copyWith(
                        color: Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Obx(() {
                        _getParticipantsImageList(context);
                        print('participants : ${controller.participants.value}');
                        return _viewRows(controller.participantsList.value);
                      }),
                      // Obx(() => _viewRows(_getParticipantsImageList(context))),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25.0.h, left: 16.0.w, right: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(
                  thickness: 1.w,
                  height: 50,
                ),
                Text(
                  'Followers',
                  style: Theme.of(context).textTheme.headline4!.copyWith(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
                Row(
                  children: <Widget>[
                    Obx(() {
                      _getListenersImageList(context);
                      print('users : ${controller.users.value}');
                      return _viewRows(controller.listenersList.value);
                    }),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomSheet: bottomBar(context),
    );
  }

  /// Helper function to get list of native views
  //HARD
  void _getParticipantsImageList(BuildContext context) {
    controller.participantsList.value = [];
    if (controller.participants.length != participantNum || controller.speakingUser.value != lastSpeakingUser) {
      controller.participants.forEach((uid) {
        print('controller.speakingUser.contains(uid)?? : ${controller.speakingUser}');
        controller.participantsList.add(Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 17.0.h),
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () => Get.to(ParticipantProfilePage()),
                      child: Container(
                        width: 83.h,
                        height: 83.h,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/you.png'),
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          // border: Border.all(width: 3, color: controller.speakingUser.contains(0)? Theme.of(context).colorScheme.primary : Colors.transparent),
                          border: Border.all(width: 3, color: controller.speakingUser.contains(uid)? Theme.of(context).colorScheme.primary : Colors.transparent),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 50.0.w,
                      right: 4.0.w,
                      top: 52.0.h,
                      bottom: 0.0.h,
                      child: GestureDetector(
                        onTap: () {
                          // if(uid == controller.currentUid) <-- 자기꺼 아니면 음소거 못하게 하기(호스트 경우엔 이 조건 없애기ㅇㅇ
                          controller.onToggleMute();
                        },
                        child: Image.asset(controller.muted.value? 'assets/icons/micButton_mute.png' : 'assets/icons/micButton.png', width: 26.w, height: 26.w),
                      ),
                    )
                  ],
                ),
              ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // 'NickName',
                    uid.toString(),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
      });
      participantNum = controller.participants.length;
    }
  }

  //HARD
  void _getListenersImageList(BuildContext context) {
    controller.listenersList.value = [];
    print('!@#@@!@#@!@#@!@#!@#@!@#@!@#@!@#@!@#@# controller.users.length: ${controller.users.length}');
    if (controller.users.length != listenerNum) {
      controller.users.forEach((uid) {
        controller.listenersList.add(Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 17.0.h),
              child: Container(
                width: 68.h,
                height: 68.h,
                child: CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/you.png'),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // 'NickName',
                    uid.toString(),
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(
                      color: Theme.of(context).colorScheme.primaryVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
      });
      listenerNum = controller.users.length;
      print('controller.users.obs: ${controller.users.obs}');
    }

  }

  /// Video view wrapper
  Widget _videoView(view) {
    return Container(
        child: Center(
          child: view,
        ));
  }

  /// Video view row wrapper
  Widget _expandedVideoRow(List<Widget> views) {
    final wrappedViews = views.map<Widget>(_videoView).toList();
    return Row(
      children: wrappedViews,
    );
  }

  Widget bottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(0, -4), // changes position of shadow
          ),
        ],
      ),
      child: BottomAppBar(
        color: Theme.of(context).colorScheme.background,
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(16.0.w, 8.0.h, 10.0.w, 8.0.h),
              child: InkWell(
                child: Container(
                  width: 80.w,
                  height: 28.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset('assets/icons/goOut_red.png', width: 20.w),
                      Text('방 나가기 ', style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: Theme.of(context).colorScheme.secondaryVariant
                      ))
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
                    border: Border.all(color: Theme.of(context).colorScheme.secondaryVariant)
                  ),
                ),
                onTap: _onCallEnd,
              ),
            ),
            Expanded(
              child: Container(
                height: 50.h,
              ),
            ),
            Obx(() => Padding(
              padding: EdgeInsets.fromLTRB(10.0.w, 6.0.h, 0.0.w, 6.0.h),
              child: InkWell(
                splashColor: Colors.transparent,
                child: Container(
                  width: 37.w,
                  child: Padding(
                    padding: EdgeInsets.all(7.0.w),
                    child: Image.asset('assets/icons/chat_black.png', width: 15.w),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: controller.isChatActive.value
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.background,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 8,
                        offset: Offset(0, 0), // changes position of shadow
                      ),
                    ],
                  ),
                ),
                onTap: () => controller.onToggleChatButton(),
              ),
            )),
            Obx(() => Padding(
              padding: EdgeInsets.fromLTRB(15.0.w, 8.0.w, 21.0.w, 8.0.w),
              child: Container(
                child: InkWell(
                  splashColor: Colors.transparent,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: controller.isParticipate.value
                        ? Theme.of(context).colorScheme.onSurface
                        : Theme.of(context).colorScheme.background,
                    child: Padding(
                      padding: EdgeInsets.all(7.0.w),
                      child: Image.asset('assets/icons/hand.png', width: 22.w),
                    ),
                  ),
                  onTap: (() {
                    if (alreadyJoin == false)
                      controller.moveWatcherToParticipant();

                    alreadyJoin = true;
                  }),
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  /// Video layout wrapper
  Widget _viewRows(List<Widget> userImageList) {
    // final views = _getRenderViews();
    var views = userImageList;
    print('asdfasdf: $views');
    if (views.length == 1) {
      return Container(
          child: Column(
            children: <Widget>[_videoView(views[0])],
          ));
    } else if (views.length <= 5) {
      return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow(views.sublist(0, views.length)),
            ],
          ));
    } else if (views.length <= 10) {
      return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow(views.sublist(0, 5)),
              _expandedVideoRow(views.sublist(5, views.length - 1))
            ],
          ));
    } else if (views.length <= 15) {
      return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow(views.sublist(0, 5)),
              _expandedVideoRow(views.sublist(5, 10)),
              _expandedVideoRow(views.sublist(15, views.length - 1))
            ],
          ));
    } else if (views.length <= 20) {
      return Container(
          child: Column(
            children: <Widget>[
              _expandedVideoRow(views.sublist(0, 5)),
              _expandedVideoRow(views.sublist(5, 10)),
              _expandedVideoRow(views.sublist(10, 15)),
              _expandedVideoRow(views.sublist(15, views.length - 1))
            ],
          ));
    }
    return Container();
  }

  void _onCallEnd() {
    controller.isParticipate.value = false;
    controller.isGroupCallPageNow.value = false;
    controller.onClose();
    Get.back();
  }
}




// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
// import 'package:herehear/agora/agoraEventController.dart';
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:herehear/bottomNavigationBar/bottom_bar.dart';
//
// class GroupCallPage extends StatefulWidget {
//   String? _title;
//   GroupCallPage(this._title);
//   final String channelName = Get.arguments;
//   @override
//   _GroupCallPageState createState() => _GroupCallPageState(_title);
// }
//
// class _GroupCallPageState extends State<GroupCallPage> {
//   String? _title;
//   _GroupCallPageState(this._title);
//
//   final String channelName = Get.arguments;
//
//   bool alreadyJoin = false;
//
//   late final controller = Get.put(AgoraEventController.groupcall(
//       channelName: channelName, role: ClientRole.Broadcaster));
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: Icon(Icons.add),
//           color: Colors.black,
//           onPressed: null,
//         ),
//         backgroundColor: Colors.black,
//         title: Center(
//           child: Text(
//             _title!,
//             style: TextStyle(
//               color: Colors.white,
//               fontFamily: 'Noto Sans CJK kr',
//               fontWeight: FontWeight.w900,
//               fontSize: 18.sp,
//             ),
//           ),
//         ),
//         actions: <Widget>[
//           //HARD
//           Padding(
//             padding: EdgeInsets.only(top: 10.0.h, right: 8.0.w),
//             child: Column(
//               children: <Widget>[
//                 Icon(Icons.people),
//                 Text(
//                   '999+',
//                   style: TextStyle(fontSize: 10),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Image.asset(
//               'assets/icons/exit.png',
//               width: 23.w,
//               color: Colors.white,
//             ),
//             onPressed: () => _onCallEnd(),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Container(
//             height: 288.h,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.only(
//                 bottomLeft: Radius.circular(12),
//                 bottomRight: Radius.circular(12),
//               ),
//               color: Theme.of(context).colorScheme.primary,
//             ),
//             child: Padding(
//               padding: EdgeInsets.only(left: 16.0.w),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.only(top: 30.0.h),
//                     child: Text(
//                       '참여',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 19.sp,
//                         fontFamily: 'Roboto',
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//                   ),
//                   Row(
//                     children: [
//                       Obx(() => _viewRows(_getParticipantsImageList())),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 25.0.h, left: 16.0.w),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   '관전',
//                   style: Theme.of(context).textTheme.headline2,
//                 ),
//                 Row(
//                   children: <Widget>[
//                     Obx(() => _viewRows(_getWatcherImageList())),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: bottomBar(context),
//     );
//   }
//
//   /// Helper function to get list of native views
//   //HARD
//   List<Widget> _getParticipantsImageList() {
//     final List<Widget> list = [];
//     if (controller.isParticipate.value) {
//       list.add(Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//             child: Container(
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundImage: AssetImage('assets/images/you.png'),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 14.0, top: 8.0),
//             child: Text(
//               'USER',
//               style: TextStyle(
//                   color: controller.isParticipate.value
//                       ? Colors.white
//                       : Color(0xFF618051)),
//             ),
//           ),
//         ],
//       ));
//     }
//     return list;
//   }
//
//   //HARD
//   List<Widget> _getWatcherImageList() {
//     final List<Widget> list = [];
//     if (controller.isParticipate.value == false) {
//       list.add(Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Padding(
//             padding: EdgeInsets.only(top: 17.0.h, right: 10.0.w),
//             child: Container(
//               child: CircleAvatar(
//                 radius: 30,
//                 backgroundImage: AssetImage('assets/images/you.png'),
//               ),
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(left: 7.0, top: 8.0),
//             child: Text(
//               'USER',
//               style: TextStyle(
//                   color: controller.isParticipate.value
//                       ? Colors.white
//                       : Color(0xFF618051)),
//             ),
//           ),
//         ],
//       ));
//       print(controller.users.obs);
//     }
//
//     return list;
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
//           Obx(() => Padding(
//                 padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
//                 child: InkWell(
//                   child: CircleAvatar(
//                     radius: 20,
//                     backgroundColor: controller.muted.value
//                         ? Theme.of(context).colorScheme.primary
//                         : Colors.white,
//                     child: Icon(
//                       controller.muted.value ? Icons.mic_off : Icons.mic,
//                       color: !alreadyJoin
//                           ? Colors.grey
//                           : controller.muted.value
//                               ? Colors.white
//                               : Colors.black,
//                       size: 30,
//                     ),
//                   ),
//                   onTap: (() {
//                     if (alreadyJoin == true) controller.onToggleMute();
//                   }),
//                 ),
//               )),
//           Padding(
//             padding: EdgeInsets.fromLTRB(10.0.w, 10.0.w, 16.0.w, 10.0.w),
//             child: InkWell(
//               child: CircleAvatar(
//                 radius: 20,
//                 backgroundColor: Colors.white,
//                 child: Icon(
//                   Icons.pan_tool_outlined,
//                   color: Colors.black,
//                   size: 28,
//                 ),
//               ),
//               onTap: (() {
//                 setState(() {
//                   if (alreadyJoin == false)
//                     controller.moveWatcherToParticipant();
//
//                   alreadyJoin = true;
//                 });
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
//     if (views.length == 1) {
//       return Container(
//           child: Column(
//         children: <Widget>[_videoView(views[0])],
//       ));
//     } else if (views.length <= 5) {
//       return Container(
//           child: Column(
//         children: <Widget>[
//           _expandedVideoRow(views.sublist(0, views.length)),
//         ],
//       ));
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
//   }
// }
