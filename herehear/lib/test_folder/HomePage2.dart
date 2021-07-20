import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/create_broadcast.dart';
import 'package:herehear/appBar/create_groupcall.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:herehear/location_data/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/groupCall/group_call.dart';

class HomePage2 extends StatelessWidget {
  // String uid;
  //
  // HomePage({this.uid});
  FirebaseAuth auth = FirebaseAuth.instance;
  String current_uid = FirebaseAuth.instance.currentUser!.uid;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(44.0.h),
            child: AppBar(
              title: Text('HERE & HEAR',
                  style: Theme.of(context).appBarTheme.titleTextStyle),
              actions: <Widget>[
                // IconButton(
                //     onPressed: _showMyDialog,
                //     color: Colors.amber,
                //     icon: Icon(Icons.add_circle)),
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
          body: RefreshIndicator(
            key: refreshKey,
            onRefresh: refreshList,
            child: ListView(
              // padding: EdgeInsets.only(left: 16.0.w, top: 25.0.r),
              children: <Widget>[
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
                          // child: Padding(
                          //   padding: const EdgeInsets.only(left: 8.0),
                          //   child: TextButton(
                          //     child: Text(
                          //         'LIVE',
                          //         style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 8)),
                          //     style: ButtonStyle(
                          //         shape: MaterialStateProperty.all<
                          //             RoundedRectangleBorder>(RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(9.0),
                          //           side: BorderSide(color: Theme.of(context).colorScheme.primary),
                          //         ))),
                          //     onPressed: null,
                          //   ),
                          // ),
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
                      stream: FirebaseFirestore.instance
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
                          children: broadcastRoomList(context, snapshot),
                        );
                        // children: List.generate(10, (int index) {
                        //   return Card(
                        //       child: Container(
                        //     width: 110.0,
                        //     height: 80.0,
                        //     child: Center(child: Text("${index + 1} 라이브")),
                        //   ));
                        // }));
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
                      stream: FirebaseFirestore.instance
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
        ));
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    await controller.getLocation().obs;
  }

  Future<void> _showMyDialog() async {
    return Get.defaultDialog(
      title: '소리 시작하기',
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextButton(
              child: Text(
                '개인 라이브',
                style: TextStyle(fontSize: 18.sp, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateBroadcastPage()),
            ),
            TextButton(
              child: Text(
                '그룹 대화',
                style: TextStyle(fontSize: 18.sp, color: Colors.black87),
              ),
              onPressed: () => Get.off(() => CreateGroupCallPage()),
            ),
          ],
        ),
      ),
    );
  }

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

  List<Widget> broadcastRoomList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs.map((room) {
      return Padding(
        padding: EdgeInsets.only(right: 12.0.w),
        child: InkWell(
          onTap: () {
            firestore.collection('broadcast').doc(room['docId']).update({
              'currentListener': FieldValue.arrayUnion([auth.currentUser!.uid])
            });
            Get.to(
              () => BroadCastPage(
                channelName: room['channelName'],
                userName: '$current_uid',
                role: ClientRole.Audience,
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 125.0.w,
                height: 125.0.h,
                child: Card(
                  margin: EdgeInsets.only(left: 0.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: Image.asset(room['image']),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 5.h),
              Text(
                room['notice'],
                style: Theme.of(context).textTheme.subtitle1,
              ),
              SizedBox(height: 4.h),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.people,
                    size: 14.w,
                  ),
                  Text(
                    room['currentListener'] == null
                        ? '0'
                        : room['currentListener'].length.toString(),
                  ),
                  SizedBox(width: 8.sp),
                  Icon(
                    Icons.favorite,
                    size: 12.w,
                  ),
                  Text(room['like'].toString()),
                ],
              )
            ],
          ),
        ),
      );
    }).toList();
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
