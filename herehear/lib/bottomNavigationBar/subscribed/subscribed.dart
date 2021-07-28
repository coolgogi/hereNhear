import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/broadcast/broadcastList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/groupCall/group_call.dart';
import 'package:herehear/users/controller/user_controller.dart';

class SubscribedPage extends GetView<UserController> {
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.0.h),
        child: AppBar(
          title:
              Text('구독', style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Photo'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.music_note),
                            title: new Text('Music'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.videocam),
                            title: new Text('Video'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.share),
                            title: new Text('Share'),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              },
              color: Colors.black87,
              icon: Image.asset('assets/icons/notification.png'),
              iconSize: 20.w,
            ),
            Padding(
              padding: EdgeInsets.only(right: 8.0.w),
              child: IconButton(
                icon: Image.asset('assets/icons/search.png'),
                iconSize: 20.w,
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: PostSearchDelegate(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        key: refreshKey,
        onRefresh: refreshList,
        child: ListView(
          // padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
              child: Text(
                '팔로잉 라이브',
                // style: Theme.of(context).textTheme.headline1,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 16.0.w, top: 12.0.h, bottom: 20.0.h),
              child: Container(
                height: 173.0.h,
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection("broadcast").snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        child: Text('라이브중인 방송이 없습니다.'),
                      );
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: broadcastRoomList(
                          context, snapshot, controller.myProfile.value),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0.w),
              child: Row(
                children: [
                  Text(
                    '팔로우 중인 카테고리',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(right: 17.0.w),
                    child: InkWell(
                      child: Text(
                        '편집',
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w700),
                      ),
                      onTap: null,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.only(left: 16.0.w, top: 8.0.h, bottom: 25.0.h),
              child: Container(
                height: 27.0.h,
                child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(3, (int index) {
                      return Padding(
                        padding: EdgeInsets.only(right: 8.0.w),
                        child: TextButton(
                          child: Text(
                            '카테고리 ${index + 1}',
                            style: TextStyle(
                                fontSize: 13.13.sp,
                                color: Theme.of(context).colorScheme.onPrimary),
                          ),
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Theme.of(context).colorScheme.primary),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                                // side: BorderSide(color: Colors.red),
                              ))),
                          onPressed: null,
                        ),
                      );
                    })),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16.0.w),
              child: Text(
                '마이 토크',
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 5.h),
              child: StreamBuilder<QuerySnapshot>(
                  stream: firestore.collection("groupcall").snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        child: Center(child: Text('생성된 대화방이 없습니다.')),
                      );
                    return Column(
                      children: groupcallRoomList(context, snapshot),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    ///////////////////////////////////////////////////////////////////////////////////
    // await controller.getLocation().obs; <-- 이거 대신 적절한 로드 로직 넣으면 됩니다!//
    //////////////////////////////////////////////////////////////////////////////////
  }

  List<Widget> groupcallRoomList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs.map((room) {
      return Column(
        children: [
          Divider(thickness: 2),
          Container(
            // width: MediaQuery.of(context).size.width,
            height: 80.0.h,
            child: InkWell(
              onTap: () {
                firestore.collection('groupcall').doc(room['docId']).update({
                  'currentListener':
                      FieldValue.arrayUnion([auth.currentUser!.uid])
                });
                Get.to(() => GroupCallPage(room['title']),
                    arguments: room['channelName']);
              },
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 16.0.w, right: 8.0.w),
                    child: Container(
                      // margin: EdgeInsets.all(0.0.w),
                      width: 70.0.h,
                      height: 70.0.h,
                      child: SizedBox(
                        child: Image.asset(room['image']),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        room['title'],
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Text(
                        room['notice'],
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }
}
