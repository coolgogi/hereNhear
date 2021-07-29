import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:herehear/broadcast/broadcastList.dart';
import 'package:herehear/groupCall/groupcallList.dart';
import 'package:herehear/location/controller/location_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';


FirebaseFirestore firestore = FirebaseFirestore.instance;

class HomePage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());
  String current_uid = '';


  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                  titleSpacing: 25.0.w,
                  title: Text('HOME',
                    style: Theme.of(context).appBarTheme.titleTextStyle),
                  expandedHeight: 131.h,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    background: Padding(
                      padding: EdgeInsets.only(left: 25.0.w),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(top: 55.0.h),
                            child: Row(
                              children: [
                                Text('안녕하세요 ', style: Theme.of(context).textTheme.headline4),
                                Text('유리한 녀석들님,', style: Theme.of(context).textTheme.headline3),
                              ],
                            ),
                          ),
                          Text('오늘도 좋은 하루 되세요.', style: Theme.of(context).textTheme.headline4),
                        ],
                      ),
                    ),
                ),
                pinned: true,
                floating: false,
                snap: false,
              ),
              SliverList(delegate: SliverChildListDelegate(
                [
                  Container(
                    constraints: BoxConstraints(minHeight: 580.0.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0.r),
                          topRight: Radius.circular(30.0.r),),
                    ),
                    child: Column(
                      children: <Widget>[
                      Padding(
                              padding: EdgeInsets.only(left: 25.0.w, top: 40.0.r),
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
                                      return Container(
                                        child: Text('라이브중인 방송이 없습니다.'),
                                      );
                                    return ListView(
                                      scrollDirection: Axis.horizontal,
                                      children: broadcastRoomList(
                                          context, snapshot),
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
                                          isEqualTo: locationController.location.value)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData)
                                      return Center(
                                          child: CircularProgressIndicator(
                                        color: Theme.of(context).colorScheme.primary,
                                      ));
                                    if (snapshot.data!.docs.length == 0 &&
                                        locationController.location.value != '')
                                      return Container(
                                        child: Center(child: Text('생성된 대화방이 없습니다.')),
                                      );
                                    return Column(
                                      children: groupcallRoomList(context, snapshot,UserController.to.myProfile.value ),
                                    );
                                  }),
                            ),
                      ],
                    ),
                  ),
                ]
              )),
            ],
          )
        ));
  }

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}
