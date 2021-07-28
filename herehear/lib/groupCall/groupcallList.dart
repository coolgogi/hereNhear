import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:herehear/broadcast/broadcastList.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'group_call.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

FirebaseAuth auth = FirebaseAuth.instance;

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
