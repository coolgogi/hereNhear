import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/create_broadcast.dart';
import 'package:herehear/appBar/create_groupcall.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:herehear/broadcast/broadcastList.dart';
import 'package:herehear/location_data/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/groupCall/group_call.dart';

class searchPage extends StatelessWidget {
  Map<String, dynamic> _data = Map();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  searchPage.withData(Map<String, dynamic> data) {
    _data = data;
  }
  searchPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.0.h),
        child: AppBar(
          title:
              Text('탐색', style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            IconButton(
              onPressed: null,
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
      body: ListView(
        // padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
            child: Row(
              children: [
                Text(
                  'TOP 라이브',
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
                          color: Theme.of(context).colorScheme.primaryVariant,
                          width: 2.0.w),
                      borderRadius: BorderRadius.all(Radius.circular(
                              9.0.r) //                 <--- border radius here
                          ),
                    ),
                    child: Center(
                      child: Text(
                        'LIVE',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primaryVariant,
                          fontSize:
                              Theme.of(context).textTheme.headline6!.fontSize,
                          fontWeight:
                              Theme.of(context).textTheme.headline6!.fontWeight,
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
            padding: EdgeInsets.only(left: 16.0.w, top: 12.0.h, bottom: 20.0.h),
            child: Container(
              height: 173.0.h,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("broadcast")
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
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
              '추천 테마',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 8.0.h, bottom: 25.0.h),
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
                                RoundedRectangleBorder>(RoundedRectangleBorder(
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
              '카테고리 ',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.0.h),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("groupcall")
                    .snapshots(),
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
      // floatingActionButtonLocation:
      //     FloatingActionButtonLocation.miniCenterFloat,
      // floatingActionButton: FloatingActionButton.extended(
      //   onPressed: null, //사용자 위치 기반으로 데이터 다시 불러오기 및 새로고침
      //   label: Text(
      //     '새로 고침',
      //     style: TextStyle(
      //       color: Colors.black87,
      //     ),
      //   ),
      //   backgroundColor: Colors.white,
      // ),
    );
  }

  // Future<void> _showMyDialog() async {
  //   return Get.defaultDialog(
  //     title: '소리 시작하기',
  //     content: SingleChildScrollView(
  //       child: Column(
  //         children: <Widget>[
  //           TextButton(
  //             child: Text(
  //               '개인 라이브',
  //               style: TextStyle(fontSize: 18.sp, color: Colors.black87),
  //             ),
  //             onPressed: () => Get.off(() => CreateBroadcastPage()),
  //           ),
  //           TextButton(
  //             child: Text(
  //               '그룹 대화',
  //               style: TextStyle(fontSize: 18.sp, color: Colors.black87),
  //             ),
  //             onPressed: () => Get.off(() => CreateGroupCallPage()),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          CreateBroadcastPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
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
                Get.to(() => GroupCallPage(), arguments: room['channelName']);
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
