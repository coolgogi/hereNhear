import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'data/broadcast_model.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/bottomNavigationBar/home/home.dart';

ListView broadcastRoomList(BuildContext context,
    AsyncSnapshot<List<BroadcastModel>> snapshot) {
  final _userData = UserController.to.myProfile.value;
  return ListView
      .builder(scrollDirection: Axis.horizontal, itemCount: snapshot.data!.length, itemBuilder: (context, index) {
        print('This is room snapshot###################################3');
    final room = snapshot.data![index];
        print('This is room snapshot###################################3');
    print(room);
    return Padding(
      padding: EdgeInsets.only(right: 16.0.w),
      child: GestureDetector(
        onTap: () async {
          await firestore.collection('broadcast').doc(room.docId).update({
            'userIds': FieldValue.arrayUnion([_userData.uid]),
            'userNickName': FieldValue.arrayUnion([_userData.nickName]),
            'userProfile': FieldValue.arrayUnion([_userData.profile]),
          });



          await Get.to(
                () =>
                BroadCastPage.myaudience(
                 //   channelName: room.docId!,
                   // userData: _userData,
                    role: ClientRole.Audience,
                    roomData: room
                ),
          );
        },
        child:Column(
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
                  borderRadius: BorderRadius.all(Radius.circular(15)),
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
                        padding: EdgeInsets.only(left: 8.0.w, right: 4.0.w),
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
                      Text('유리한 녀석들',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                            fontSize: 13.sp,
                          )),
                      Expanded(child: Container()),
                      Icon(
                        Icons.people,
                        size: 17.w,
                        color: Colors.white,
                      ),
                      Text(
                        room.users ==null
                            ? ' 0'
                            : ' ${room.users.length.toString()}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                          color: Colors.white,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(width: 8.sp),
                      Icon(
                        Icons.favorite,
                        size: 14.w,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 13.5.w),
                        child: Text(
                          ' ${room.like.toString()}',
                          style: Theme.of(context).textTheme.subtitle1!.copyWith(
                            color: Colors.white,
                            fontSize: 13.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 5.0.w, top: 10.0.h, bottom: 16.0.h),
              child: Text('같이 대화하면서 놀아요!', style: Theme.of(context).textTheme.headline4),
            ),
          ],
        ),
      ),
    );
  },
  );
}