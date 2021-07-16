import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/create_broadcast.dart';
import 'package:herehear/appBar/create_groupcall.dart';
import 'package:herehear/appBar/searchBar.dart';
import 'package:herehear/location_data/location.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/groupCall/group_call.dart';


class SubscribedPage extends StatelessWidget {
  // String uid;
  //
  // HomePage({this.uid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(44.0.h),
        child: AppBar(
          title: Text(
              '구독',
              style: Theme.of(context).appBarTheme.titleTextStyle),
          actions: <Widget>[
            // IconButton(
            //     onPressed: _showMyDialog,
            //     color: Colors.amber,
            //     icon: Icon(Icons.add_circle)),
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
              iconSize: 20.w,),
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
            child: Text(
              '팔로잉 라이브',
              // style: Theme.of(context).textTheme.headline1,
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16.0.w, top: 12.0.h, bottom: 20.0.h),
            child: Container(
              height: 173.0.h,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("broadcast").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
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
                    child: Text('편집', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),),
                    onTap: null,
                  ),
                )
              ],
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
                        child: Text('카테고리 ${index + 1}', style: TextStyle(fontSize: 13.13.sp, color: Theme.of(context).colorScheme.onPrimary),),
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Theme.of(context).colorScheme.primary),
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
              '마이 토크',
              style: Theme.of(context).textTheme.headline2,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection("groupcall").snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData)
                    return Container(
                      child: Center(child: Text('생성된 대화방이 없습니다.')),
                    );
                  return Column(
                    children: groupcallRoomList(context, snapshot),
                  );
                }
            ),
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

  List<Widget> broadcastRoomList(BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs
        .map((room) {
      return Padding(
        padding: EdgeInsets.only(right: 12.0.w),
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
                      width:120,
                      height:120,
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
                Icon(Icons.people, size: 14.w,),
                Text(
                  room['currentListener'] == null
                    ? '0'
                    : room['currentListener'].length.toString(),),
                SizedBox(width: 8.sp),
                Icon(Icons.favorite, size: 12.w,),
                Text( room['like'].toString()),
              ],
            )
          ],
        ),
      );
    }).toList();
  }

  List<Widget> groupcallRoomList(BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs
        .map((room) {
      return Column(
        children: [
          Divider(thickness: 2),
          Container(
            // width: MediaQuery.of(context).size.width,
            height: 80.0.h,
            child: InkWell(
              onTap: (){
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
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.all(
                            Radius.circular(6.0.r) //                 <--- border radius here
                        ),
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
