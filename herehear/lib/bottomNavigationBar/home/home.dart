import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/action_widget.dart';
import 'package:herehear/appBar/drawer/drawer.dart';
import 'package:herehear/appBar/notification/notification.dart';
import 'package:herehear/appBar/set_location.dart';
import 'package:herehear/bottomNavigationBar/community/free_board/record_test.dart';
// import 'package:herehear/bottomNavigationBar/community/free_board/record_test22.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/bottomNavigationBar/home/scroll_controller.dart';
import 'package:herehear/groupCall/groupcall_list.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/participant_profile.dart';
import 'package:herehear/users/controller/user_controller.dart';
import '../../broadcast/data/broadcast_model.dart' as types;
import 'package:herehear/groupCall/data/group_call_model.dart' as types;

import 'broadcastDetail.dart';
import 'groupCallDetail.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomePage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = Get.put(ScrollOpacityController());
  final locationController = Get.put(LocationController());
  final searchController = Get.put(SearchBarController());
  final UserController userController = Get.find();
  String current_uid = '';
  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    _scrollController.onInit();
    return Obx(() => Scaffold(
          key: _scaffoldKey,
          endDrawer: DrawerWidget(),
          appBar: AppBar(
            titleSpacing: 22.5.w,
            title: GestureDetector(
              onTap: (() {
                searchController.initialSearchText();
                Get.to(SetLocationPage());
              }),
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.place_outlined,
                    size: 19.h,
                  ),
                  Text(' ${UserController.to.myProfile.value.location}',
                      style: Theme.of(context).appBarTheme.titleTextStyle),
                  Icon(
                    Icons.expand_more,
                    size: 19.h,
                  ),
                ],
              ),
            ),
            actions: action_widget(_scaffoldKey),
          ),
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return true;
            },
            child: SingleChildScrollView(
                controller: _scrollController.scrollController.value,
                child: Column(children: <Widget>[
                  Obx(() => AnimatedOpacity(
                      // key: widgetKey,
                      duration: Duration(milliseconds: 1),
                      opacity: _scrollController.opacity.value,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 25.0.w,
                            top: 20.0.h,
                            right: 26.0.w,
                            bottom: 20.h),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: [
                                    Text('??????????????? ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    Text(
                                        '${UserController.to.myProfile.value.nickName!}???',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline1),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('????????? ?????? ?????? ?????????. ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3),
                                    Image(
                                      image:
                                          AssetImage('assets/icons/leaf.png'),
                                      width: 20.0.w,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Expanded(child: Container()),
                            CircleAvatar(
                              radius: 21.r,
                              backgroundImage: AssetImage(
                                  UserController.to.myProfile.value.profile!),
                            ),
                          ],
                        ),
                      ))),
                  Container(
                    decoration: BoxDecoration(
                        border:
                            Border.all(width: 1.0.w, color: Colors.transparent),
                        //color is transparent so that it does not blend with the actual color specified
                        color: Colors
                            .transparent // Specifies the background color and the opacity
                        ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0.w),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'HERE ?????????',
                            // style: Theme.of(context).textTheme.headline1,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 5.0.w),
                            child: Image.asset('assets/icons/live.png',
                                width: 43.w, height: 18.h),
                          ),
                          Expanded(child: Container()),
                          IconButton(
                              onPressed: () => Get.to(BroadcastDetailPage()),
                              icon: Icon(Icons.arrow_forward_ios,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  size: 22.w)),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 21.0.w, top: 16.0.h),
                    child: Container(
                      height: 200.0.h,
                      child: StreamBuilder<List<types.BroadcastModel>>(
                        stream: MyFirebaseChatCore.instance
                            .broadcastRoomsWithLocation(),
                        initialData: const [],
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ));
                          }

                          if (snapshot.data!
                                  .isEmpty && //snapshot.data!.docs.length == 0
                              locationController.location.value != '')
                            return Padding(
                              padding: EdgeInsets.only(top: 50.0.h),
                              child: Container(
                                child: Text('??????????????? ????????? ????????????.'),
                              ),
                            );
                          else {
                            return broadcastRoomList(context, snapshot);
                          }
                        },
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 25.0.w),
                        child: Text(
                          'HEAR CHAT',
                          style: Theme.of(context).textTheme.headline1,
                        ),
                      ),
                      Expanded(child: Container()),
                      IconButton(
                          onPressed: () => Get.to(GroupCallDetailPage()),
                          icon: Icon(Icons.arrow_forward_ios,
                              color: Theme.of(context).colorScheme.onSurface,
                              size: 22.w)),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0.h, bottom: 50.h),
                    child: StreamBuilder<List<types.GroupCallModel>>(
                        stream: MyFirebaseChatCore.instance
                            .groupCallRoomsWithLocation(),
                        initialData: const [],
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                                child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.primary,
                            ));
                          }
                          if (snapshot.data!
                                  .isEmpty && //snapshot.data!.docs.length == 0
                              locationController.location.value != '')
                            return Padding(
                              padding: EdgeInsets.only(top: 50.0.h),
                              child: Container(
                                child: Center(child: Text('????????? ???????????? ????????????.')),
                              ),
                            );
                          return NotificationListener<
                                  OverscrollIndicatorNotification>(
                              onNotification: (overScroll) {
                                overScroll.disallowGlow();
                                return true;
                              },
                              child: groupcallRoomList(context, snapshot));
                        }),
                  ),
                  SizedBox(height: 100.h),
                ])),
          ),
        ));
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep ?????? ????????? ???.
    locationController.getLocation().obs;
  }
}
