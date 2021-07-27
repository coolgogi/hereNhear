import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/notification/notification.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/broadcast/broadcastList.dart';
import 'package:herehear/groupCall/group_call2.dart';
import 'package:herehear/location_data/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:badges/badges.dart';

class HomePage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final controller = Get.put(LocationController());
  String current_uid = '';
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late Map<String, dynamic> _data;
  HomePage.withData(Map<String, dynamic> data) {
    _data = data;
  }
  HomePage();
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(44.0.h),
            child: AppBar(
              title: Text('HERE & HEAR',
                  style: Theme.of(context).appBarTheme.titleTextStyle),
              actions: <Widget>[
                controller.count > 0
                    ? Badge(
                        badgeContent: Text(controller.count.toString(),
                            style:
                                TextStyle(color: Colors.white, fontSize: 11)),
                        position: BadgePosition.topEnd(top: 0, end: 5),
                        child: IconButton(
                          onPressed: () => Get.to(() => NotificationPage()),
                          color: Colors.black87,
                          icon: Image.asset('assets/icons/notification.png'),
                          iconSize: 20.w,
                        ),
                      )
                    : IconButton(
                        onPressed: () => Get.to(() => NotificationPage()),
                        // => Get.off(() => Notification()),
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
                    '현재 위치 : 포항시 북구',
                    // style: Theme.of(context).textTheme.headline1,
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
                  child: Row(
                    children: <Widget>[
                      Text(
                        '실시간 소리',
                        // style: Theme.of(context).textTheme.headline1,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 3.0.w),
                        child: Container(
                          width: 41.w,
                          height: 17.h,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                                width: 2.0.w),
                            borderRadius: BorderRadius.all(Radius.circular(9.0
                                    .r) //                 <--- border radius here
                                ),
                          ),
                          child: Center(
                            child: Text(
                              'LIVE',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .primaryVariant,
                                fontSize: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .fontSize,
                                fontWeight: Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .fontWeight,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(child: Container()),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 16.0.w, top: 12.0.h, bottom: 20.0.h),
                  child: Container(
                    height: 173.0.h,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection("broadcast")
                          .where('location',
                              isEqualTo: controller.location.value)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        print('done!!');
                        if (!snapshot.hasData)
                          return Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ));
                        if (snapshot.data!.docs.length == 0 &&
                            controller.location.value != '')
                          return Container(
                            child: Text('라이브중인 방송이 없습니다.'),
                          );
                        return ListView(
                          scrollDirection: Axis.horizontal,
                          children: broadcastRoomList(context, snapshot, _data),
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w),
                  child: Text(
                    '토크',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 9.0.h),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: firestore
                          .collection("groupcall")
                          .where('location',
                              isEqualTo: controller.location.value)
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData)
                          return Center(
                              child: CircularProgressIndicator(
                            color: Theme.of(context).colorScheme.primary,
                          ));
                        if (snapshot.data!.docs.length == 0 &&
                            controller.location.value != '')
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
        ));
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    controller.getLocation().obs;
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
                      child: SizedBox(child: Image.asset(room['image'])),
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
