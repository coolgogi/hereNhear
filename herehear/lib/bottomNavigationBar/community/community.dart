import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/appBar/searchBar.dart';

import 'package:herehear/broadcast/broadcastList.dart';
import 'package:herehear/groupCall/groupcallList.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';

import 'free_board/free_board.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;

class CommunityPage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());
  String current_uid = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 25.0.w,
        title: Text('COMMUNITY', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(
            icon: Image.asset('assets/icons/search.png'),
            iconSize: 20.w,
            onPressed: () {
              showSearch(
                context: context,
                delegate: PostSearchDelegate(),
              );
            },
          ),
          IconButton(onPressed: null, icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(onPressed: null, icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // SizedBox(height: 81.0.h),
          Padding(
            padding: EdgeInsets.only(left: 25.0.w),
            child: Row(
              children: <Widget>[
                Text(
                  'HEAR 게시판',
                  // style: Theme.of(context).textTheme.headline1,
                  style: Theme.of(context).textTheme.headline1,
                ),
                Expanded(child: Container()),
                IconButton(
                    onPressed: () => Get.to(FreeBoardPage()),
                    icon: Icon(Icons.arrow_forward_ios)),
              ],
            ),
          ),
          Obx(() => Padding(
            padding: EdgeInsets.only(
                left: 21.0.w, top: 19.0.h),
            child: Container(
              height: 177.0.h,
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection("broadcast")
                    .where('location',
                    isEqualTo: locationController.location.value)
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
                      locationController.location.value != '')
                    return Padding(
                      padding: EdgeInsets.only(top: 50.0.h),
                      child: Container(
                        child: Text('아직 게시글이 없습니다.'),
                      ),
                    );
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      postCard(context),
                      postCard(context),
                      postCard(context),
                    ]
                  );
                },
              ),
            ),
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25.0.w),
                child: Text(
                  '놀이터',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Expanded(child: Container()),
              IconButton(
                  onPressed: null,
                  icon: Icon(Icons.arrow_forward_ios)),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 24.0.w),
            child: Column(
              children: <Widget>[
                playThemeList(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget postCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 39.0.h, right: 16.0.w),
      width: 144.0.w,
      height: 119.0.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15)
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 8,
            offset: Offset(1, 4), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: null,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 51.0.h),
              child: Center(child: Text('연애 상담 해드려요.', style: Theme.of(context).textTheme.bodyText1)),
            ),
            Expanded(child: Container()),
            Padding(
              padding: EdgeInsets.only(right: 11.0.w, bottom: 11.0.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.people,
                    size: 14.w,
                  ),
                  Text(
                    // _roomData['currentListener'] == null
                    //     ? ' 0'
                    //     : ' ${_roomData['currentListener'].length.toString()}',
                    '26',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  SizedBox(width: 8.0.w),
                  Icon(
                    Icons.favorite,
                    size: 12.w,
                  ),
                  Text(
                    // ' ${_roomData['like'].toString()}',
                    '35',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget playThemeList(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 27.0.h),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 15.0.h, right: 16.0.w),
            width: 327.0.w,
            height: 95.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(1, 4), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: null,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0.w, right: 15.0.w,),
                    child: Image.asset('assets/images/sing.png'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 27.0.h),
                        child: Row(
                          children: [
                            Text('노래방', style: Theme.of(context).textTheme.bodyText1),
                            Padding(
                              padding: EdgeInsets.only(left: 4.0.w),
                              child: Image.asset('assets/images/mike.png', width: 13.0.w,),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Center(child: Text('당신의 실력을 맘껏 뽐내보세요.', style: Theme.of(context).textTheme.bodyText2)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 15.0.h, right: 16.0.w),
            width: 327.0.w,
            height: 95.0.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(1, 4), // changes position of shadow
                ),
              ],
            ),
            child: InkWell(
              onTap: null,
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12.0.w, right: 15.0.w,),
                    child: Image.asset('assets/images/voiceCopy.png'),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 27.0.h),
                        child: Row(
                          children: [
                          Text('성대모사', style: Theme.of(context).textTheme.bodyText1),
                          Padding(
                            padding: EdgeInsets.only(left: 4.0.w),
                            child: Image.asset('assets/images/mike2.png', width: 13.0.w,),
                          )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0.h),
                        child: Center(child: Text('1번 테이블에 봉골레 파스타 하나.', style: Theme.of(context).textTheme.bodyText2)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}