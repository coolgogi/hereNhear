import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/data/user_model.dart';
import 'group_call.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/home/HomePage.dart';

import '';

List<Widget> groupcallRoomList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot , UserModel _userData) {
  return broadcastSnapshot.data!.docs.map((_roomData) {
    return Column(
      children: [
        Divider(thickness: 2),
        Container(
          // width: MediaQuery.of(context).size.width,
          height: 80.0.h,
          child: InkWell(
            onTap: () {
              firestore.collection('groupcall').doc(_roomData['docId']).update({
                'currentListener':
                    FieldValue.arrayUnion([_userData.uid]),
              });
              Get.to(() => GroupCallPage(_roomData['title']),
                  arguments: _roomData['channelName']);
            },
            child: Row(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 16.0.w, right: 8.0.w),
                  child: Container(
                    // margin: EdgeInsets.all(0.0.w),
                    width: 70.0.h,
                    height: 70.0.h,
                    child: SizedBox(child: Image.asset(_roomData['image'])),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _roomData['title'],
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      _roomData['notice'],
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
