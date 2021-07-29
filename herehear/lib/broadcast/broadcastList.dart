import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/bottomNavigationBar/home/HomePage.dart';

Map<String, dynamic> data = new Map();

List<Widget> broadcastRoomList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
  final _userData = UserController.to.myProfile.value;
  return broadcastSnapshot.data!.docs.map((_roomData) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0.w),
      child: InkWell(
        onTap: () async {
          firestore.collection('broadcast').doc(_roomData['docId']).update({
            'currentListener': FieldValue.arrayUnion([_userData.uid]),
            'userNickName': FieldValue.arrayUnion([_userData.nickName]),
            'userProfile': FieldValue.arrayUnion([_userData.profile]),
          });
          await getData(_roomData['docId']).whenComplete(() => Get.to(
                () => BroadCastPage.audience(
                  channelName: _roomData['channelName'],
                  userName: _userData.uid,
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
                      child: Image.asset(_roomData['image']),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              _roomData['notice'],
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
                  _roomData['currentListener'] == null
                      ? '0'
                      : _roomData['currentListener'].length.toString(),
                ),
                SizedBox(width: 8.sp),
                Icon(
                  Icons.favorite,
                  size: 12.w,
                ),
                Text(_roomData['like'].toString()),
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
