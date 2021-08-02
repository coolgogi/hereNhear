import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/bottomNavigationBar/home/home.dart';

Map<String, dynamic> data = new Map();

List<Widget> broadcastRoomList(
    BuildContext context, AsyncSnapshot<QuerySnapshot> broadcastSnapshot) {
  final _userData = UserController.to.myProfile.value;
  return broadcastSnapshot.data!.docs.map((_roomData) {
    return Padding(
      padding: EdgeInsets.only(right: 16.0.w),
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
                  userData: _userData,
                  role: ClientRole.Audience,
                  roomData: data,
                ),
              ));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 5.0.w),
              child: Container(
                width: 250.0.w,
                height: 141.0.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/images/groupcall/fish.jpg")
                  ),
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 8,
                      offset: Offset(1, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.only(top: 110.0.h, bottom: 8.0.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 8.0.w, right: 6.0.w),
                        child: Container(
                          width: 40.0.w,
                          height: 40.0.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/you2.jpg'),
                              fit: BoxFit.fitWidth,
                            )
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 45.0.w),
                        child: Text('유리한 녀석들', style: TextStyle(
                          color: Colors.white,
                          fontSize: 13.sp,
                          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                        )),
                      ),
                      Icon(
                        Icons.people,
                        size: 17.w,
                        color: Colors.white,
                      ),
                      Text(
                          _roomData['currentListener'] == null
                              ? ' 0'
                              : ' ${_roomData['currentListener'].length.toString()}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                            fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                          ),
                      ),
                      SizedBox(width: 8.sp),
                      Icon(
                        Icons.favorite,
                        size: 14.w,
                        color: Colors.white,
                      ),
                      Text(
                        ' ${_roomData['like'].toString()}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Theme.of(context).textTheme.bodyText1!.fontSize,
                          fontFamily: Theme.of(context).textTheme.bodyText2!.fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0.w, top: 10.0.h, bottom: 24.0.h),
              child: Text('같이 대화하면서 놀아요!', style: Theme.of(context).textTheme.bodyText1),
            ),
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
