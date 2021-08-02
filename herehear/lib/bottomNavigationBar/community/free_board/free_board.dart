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


FirebaseFirestore firestore = FirebaseFirestore.instance;

class FreeBoardPage extends StatelessWidget {
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  final locationController = Get.put(LocationController());
  String current_uid = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios),
        //   onPressed: null,
        // ),
        centerTitle: true,
        title: Text('HEAR 게시판', style: Theme.of(context).appBarTheme.titleTextStyle),
        actions: <Widget>[
          IconButton(onPressed: null, icon: Image.asset('assets/icons/bell.png', height: 17.0.h)),
          IconButton(onPressed: null, icon: Image.asset('assets/icons/more.png', height: 17.0.h)),
        ],
      ),
      body: ListView(
        children: <Widget>[
          // SizedBox(height: 81.0.h),
          Padding(
            padding: EdgeInsets.only(left: 36.0.w, top: 32.0.h),
            child: Row(
              children: <Widget>[
                Text(
                  '당신의 하루를 위로할 HEAR',
                  // style: Theme.of(context).textTheme.headline1,
                  style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 6.0.w),
                  child: Image.asset('assets/icons/leaf2.png', width: 13.0.w,),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: 35.0.w, top: 32.0.h),
            child: postList(context),
          ),
        ],
      ),
    );
  }

  Widget postList(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
        Row(
          children: [
            postCard(context),
            postCard(context),
          ],
        ),
      ],
    );
  }

  Widget postCard(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0.h, right: 16.0.w),
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

  Future<void> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 0)); //thread sleep 같은 역할을 함.
    locationController.getLocation().obs;
  }
}