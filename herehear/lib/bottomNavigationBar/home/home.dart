import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/set_location.dart';
import 'package:herehear/bottomNavigationBar/search/searchBar_controller.dart';
import 'package:herehear/broadcast/broadcast_list.dart';
import 'package:herehear/chatting/my_firebase_chat.dart';
import 'package:herehear/bottomNavigationBar/home/scroll_controller.dart';
import 'package:herehear/groupCall/groupcall_list.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/login/signIn.dart';
import 'package:herehear/users/controller/user_controller.dart';
import '../../broadcast/data/broadcast_model.dart' as types;

FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomePage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final _scrollController = Get.put(ScrollOpacityController());
  final locationController = Get.put(LocationController());
  final searchController = Get.put(SearchBarController());
  final UserController userController = Get.find();
  String current_uid = '';

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
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
            actions: <Widget>[
              IconButton(
                  onPressed: null,
                  icon: Image.asset('assets/icons/bell.png', height: 18.0.h)),
              IconButton(
                  onPressed: null,
                  icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
            ],
          ),
          body: SingleChildScrollView(
              controller: _scrollController.scrollController.value,
              child: Column(children: <Widget>[
                Obx(() => AnimatedOpacity(
                    // key: widgetKey,
                    duration: Duration(milliseconds: 1),
                    opacity: _scrollController.opacity.value,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 25.0.w,
                          top: 23.0.h,
                          right: 26.0.w,
                          bottom: 38.h),
                      child: Row(
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  Text('안녕하세요 ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  Text(
                                      '${UserController.to.myProfile.value.nickName!}님',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                ],
                              ),
                              Row(
                                children: [
                                  Text('오늘도 좋은 하루 되세요. ',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3),
                                  Image(
                                    image: AssetImage('assets/icons/leaf.png'),
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
                      border: Border.all(width: 1.0, color: Colors.transparent),
                      //color is transparent so that it does not blend with the actual color specified
                      color: Colors
                          .transparent // Specifies the background color and the opacity
                      ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 25.0.w),
                    child: Row(
                      children: <Widget>[
                        Text(
                          'HERE 라이브',
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
                            onPressed: () => Get.to(LoginPage()),
                            icon: Icon(Icons.arrow_forward_ios)),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 21.0.w, top: 16.0.h),
                  child: Container(
                    height: 195.0.h,
                    child: StreamBuilder<List<types.BroadcastModel>>(
                      stream: MyFirebaseChatCore.instance.broadcastRoomsWithLocation(),
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
                              child: Text('라이브중인 방송이 없습니다.'),
                            ),
                          );
                        return broadcastRoomList(context, snapshot);
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
                        onPressed: null, icon: Icon(Icons.arrow_forward_ios)),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 16.0.h),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection("groupcall")
                          .where('location',
                              isEqualTo:
                                  UserController.to.myProfile.value.location)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ));
                        if (snapshot.data!.docs.length == 0 &&
                            UserController.to.myProfile.value.location != '')
                          return Padding(
                            padding: EdgeInsets.only(top: 50.0.h),
                            child: Container(
                              child: Center(child: Text('생성된 대화방이 없습니다.')),
                            ),
                          );
                        return Column(
                          children: groupcallRoomList(context, snapshot),
                        );
                      }),
                ),
              ])),
        ));
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}
