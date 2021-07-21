import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
Map<String, dynamic> data = new Map();

List<Widget> broadcastRoomList(
    BuildContext context,
    AsyncSnapshot<QuerySnapshot> broadcastSnapshot,
    Map<String, dynamic> _data) {
  return broadcastSnapshot.data!.docs.map((room) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0.w),
      child: InkWell(
        onTap: () async {
          firestore.collection('broadcast').doc(room['docId']).update({
            'currentListener': FieldValue.arrayUnion([_data['uid']]),
            'userNickName': FieldValue.arrayUnion([_data['nickName']]),
            'userProfile': FieldValue.arrayUnion([_data['profile']]),
          });
          await getData(room['docId']).whenComplete(() => Get.to(
                () => BroadCastPage.audience(
                  channelName: room['channelName'],
                  userName: _data['uid'],
                  role: ClientRole.Audience,
                  dbData: data,
                ),
              ));
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

Future<void> getData(String docID) async {
  var temp =
      await FirebaseFirestore.instance.collection('broadcast').doc(docID).get();
  Map<String, dynamic> _data = temp.data()!;
  data = _data;
}

/*

  List<Widget> broadcastRoomList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
    return broadcastSnapshot.data!.docs.map((room) {
      return Padding(
        padding: EdgeInsets.only(right: 12.0.w),
        child: InkWell(
          onTap: () {
            firestore.collection('broadcast').doc(room['docId']).update({
              'currentListener': FieldValue.arrayUnion([_data['uid']]),
              'userNickName': FieldValue.arrayUnion([_data['nickName']]),
              'userProfile': FieldValue.arrayUnion([_data['profile']]),
            });

            Get.to(
              () => BroadCastPage(
                channelName: room['channelName'],
                userName: _data['uid'],
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
 */
