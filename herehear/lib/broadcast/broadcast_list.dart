import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:herehear/bottomNavigationBar/myPage/edit_profile.dart';
import 'package:herehear/broadcast/broadcast.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'data/broadcast_model.dart';
import 'package:herehear/users/controller/user_controller.dart';
import 'package:herehear/bottomNavigationBar/home/home.dart';

ListView broadcastRoomList(
    BuildContext context, AsyncSnapshot<List<BroadcastModel>> snapshot) {
  final _userData = UserController.to.myProfile.value;
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      final room = snapshot.data![index];
      return Padding(
        padding: EdgeInsets.only(right: 10.0.w),
        child: GestureDetector(
          onTap: () async {
            room.users.add(UserController.to.myProfile.value);

            await firestore
                .collection('broadcast')
                .doc(room.roomInfo.channelName)
                .update({
              'userIds': FieldValue.arrayUnion(
                  [UserController.to.myProfile.value.uid]),
              'userNickName': FieldValue.arrayUnion([_userData.nickName]),
              'userProfile': FieldValue.arrayUnion([_userData.profile]),
            });

            await _handleCameraAndMic(Permission.microphone);
            await Get.to(
              () => BroadCastPage.audience(
                  //   channelName: room.docId!,
                  // userData: _userData,
                  role: ClientRole.Audience,
                  roomData: room),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 314.0.w,
                height: 151.0.h,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage("assets/images/groupcall/fish.jpg")),
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(15.r)),
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
                        padding: EdgeInsets.only(left: 12.0.w, right: 10.0.w),
                        child: Container(
                          width: 40.0.w,
                          height: 40.0.h,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image:
                                    AssetImage(room.roomInfo.hostInfo.profile!),
                                fit: BoxFit.fitWidth,
                              )),
                        ),
                      ),
                      Text(room.roomInfo.hostInfo.nickName!,
                          style:
                              Theme.of(context).textTheme.headline4!.copyWith(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                  )),
                      Expanded(child: Container()),
                      Icon(
                        Icons.people,
                        size: 20.w,
                        color: Colors.white,
                      ),
                      Text(
                        ' ${room.users.length.toString()}',
                        style: Theme.of(context).textTheme.subtitle1!.copyWith(
                              color: Colors.white,
                              fontSize: 13.sp,
                            ),
                      ),
                      SizedBox(width: 12.w),
                      Icon(
                        Icons.favorite,
                        size: 16.w,
                        color: Colors.white,
                      ),
                      Padding(
                        padding: EdgeInsets.only(right: 15.w),
                        child: Text(
                          ' ${room.like.toString()}',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.0.w, top: 10.0.h, bottom: 16.0.h),
                    child: Text(room.roomInfo.title,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  SizedBox(width: 10.w),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13.r)),
                      border: Border.all(
                          width: 1.5.w,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/categoryIcon/book.png',
                                width: 10.w, height: 10.w),
                            SizedBox(width: 2.w),
                            Text(
                              '??????',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      fontSize: 11.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

ListView broadcastRoomVerticalList(
    BuildContext context, AsyncSnapshot<List<BroadcastModel>> snapshot) {
  final _userData = UserController.to.myProfile.value;
  return ListView.builder(
    shrinkWrap: true,
    itemCount: snapshot.data!.length,
    itemBuilder: (context, index) {
      final room = snapshot.data![index];
      return Padding(
        padding: EdgeInsets.only(right: 16.0.w),
        child: GestureDetector(
          onTap: () async {
            //room.users.add(UserController.to.myProfile.value);

            await firestore
                .collection('broadcast')
                .doc(room.roomInfo.channelName)
                .update({
              'userIds': FieldValue.arrayUnion([_userData.uid]),
              'userNickName': FieldValue.arrayUnion([_userData.nickName]),
              'userProfile': FieldValue.arrayUnion([_userData.profile]),
            });

            await Get.to(
              () => BroadCastPage.audience(
                  //   channelName: room.docId!,
                  // userData: _userData,
                  role: ClientRole.Audience,
                  roomData: room),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 5.0.w),
                child: Container(
                  width: 314.0.w,
                  height: 186.0.h,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage("assets/images/groupcall/fish.jpg")),
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15.r)),
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
                    padding: EdgeInsets.only(top: 140.0.h, bottom: 8.0.h),
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
                                )),
                          ),
                        ),
                        Text('????????? ?????????',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
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
                          ' ${room.users.length.toString()}',
                          style:
                              Theme.of(context).textTheme.subtitle1!.copyWith(
                                    color: Colors.white,
                                    fontSize: 13.sp,
                                  ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.favorite,
                          size: 14.w,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 13.5.w),
                          child: Text(
                            ' ${room.like.toString()}',
                            style:
                                Theme.of(context).textTheme.subtitle1!.copyWith(
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
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        left: 5.0.w, top: 10.0.h, bottom: 16.0.h),
                    child: Text('?????? ??????????????? ?????????!',
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  Expanded(child: Container()),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(13.r)),
                      border: Border.all(
                          width: 1.5.w,
                          color: Theme.of(context).colorScheme.primary),
                    ),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 1.h, 4.w, 1.h),
                        child: Row(
                          children: [
                            Image.asset('assets/icons/categoryIcon/book.png',
                                width: 10.w, height: 10.w),
                            SizedBox(width: 2.w),
                            Text(
                              '??????',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(
                                      fontSize: 11.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _handleCameraAndMic(Permission permission) async {
  final status = await permission.request();
}
